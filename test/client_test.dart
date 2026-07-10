import 'dart:convert';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:http/http.dart' show Response;
import 'package:test/test.dart';

import 'mock_support.dart';

/// Serves an account whose id and owner name echo the requested account id, so
/// tests can prove which id each fanned-out request used.
Future<Response> _accountByIdHandler(RecordedRequest req) async {
  final segments = req.url.pathSegments.where((s) => s.isNotEmpty).toList();
  final id = segments.last; // .../accounts/<id>/
  return jsonResponse(
    '{"id":"$id","created":null,"last_accessed":null,"iban":null,'
    '"institution_id":"INST","status":null,"owner_name":"Owner $id"}',
  );
}

Requisition requisitionWith({
  RequisitionStatus? status = RequisitionStatus.created,
  List<String>? accounts,
}) => Requisition(
  id: 'req-123',
  created: null,
  redirect: 'https://www.gocardless.com',
  status: status,
  institutionId: 'INST',
  agreement: 'agr-123',
  reference: null,
  accounts: accounts,
  userLanguage: null,
  link: 'https://ob.example/req-123',
  ssn: null,
  accountSelection: null,
  redirectImmediate: null,
);

void main() {
  group('dateToStringFormat', () {
    final client = GoCardlessBankAccountDataClient(
      secretId: 'x',
      secretKey: 'y',
    );

    test('returns null for a null date', () {
      expect(client.dateToStringFormat(null), isNull);
    });

    test('formats as zero-padded yyyy-MM-dd', () {
      expect(client.dateToStringFormat(DateTime(2024, 1, 5)), '2024-01-05');
      expect(client.dateToStringFormat(DateTime(2024, 12, 31)), '2024-12-31');
    });

    test('pads a short year to four digits', () {
      expect(client.dateToStringFormat(DateTime(5, 3, 7)), '0005-03-07');
    });

    test('ignores the time component', () {
      expect(
        client.dateToStringFormat(DateTime(2024, 3, 7, 15, 30, 59)),
        '2024-03-07',
      );
    });
  });

  group('getAccounts fan-out', () {
    test(
      'returns an empty list (and makes no calls) when accounts is null',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(_accountByIdHandler, log: log);

        final accounts = await client.getAccounts(
          requisitionWith(accounts: null),
        );

        expect(accounts, isEmpty);
        expect(log, isEmpty, reason: 'no requisition/account calls expected');
      },
    );

    test('returns an empty list for an empty accounts list', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(_accountByIdHandler, log: log);

      final accounts = await client.getAccounts(requisitionWith(accounts: []));

      expect(accounts, isEmpty);
    });

    test('fetches one account per id, preserving order', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(_accountByIdHandler, log: log);

      final accounts = await client.getAccounts(
        requisitionWith(accounts: ['acc-1', 'acc-2', 'acc-3']),
      );

      expect(accounts.map((a) => a.id), ['acc-1', 'acc-2', 'acc-3']);
      expect(accounts.map((a) => a.ownerName), [
        'Owner acc-1',
        'Owner acc-2',
        'Owner acc-3',
      ]);

      final apiPaths = log
          .where((r) => !r.isToken)
          .map((r) => r.url.path)
          .toList();
      expect(apiPaths, [
        '/api/v2/accounts/acc-1/',
        '/api/v2/accounts/acc-2/',
        '/api/v2/accounts/acc-3/',
      ]);
    });

    test(
      'getAccountsById fetches the requisition first, then its accounts',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient((req) async {
          final segments = req.url.pathSegments
              .where((s) => s.isNotEmpty)
              .toList();
          final resource = segments[2]; // after api/v2
          if (resource == 'requisitions') {
            return jsonResponse(
              requisitionJson(status: 'LN', accounts: ['acc-1', 'acc-2']),
            );
          }
          return _accountByIdHandler(req);
        }, log: log);

        final accounts = await client.getAccountsById('req-123');

        expect(accounts.map((a) => a.id), ['acc-1', 'acc-2']);

        final apiPaths = log
            .where((r) => !r.isToken)
            .map((r) => r.url.path)
            .toList();
        expect(apiPaths, [
          '/api/v2/requisitions/req-123/',
          '/api/v2/accounts/acc-1/',
          '/api/v2/accounts/acc-2/',
        ]);
      },
    );
  });

  group('waitForRequisitionLink', () {
    test('polls getRequisition until the status becomes linked', () async {
      final log = <RecordedRequest>[];
      var polls = 0;
      final client = buildClient((req) async {
        polls++;
        // Not linked for the first two polls, then linked.
        final status = polls < 3 ? 'CR' : 'LN';
        return jsonResponse(requisitionJson(status: status));
      }, log: log);

      final linked = await client.waitForRequisitionLinkById('req-123');

      expect(polls, 3);
      expect(linked.status, RequisitionStatus.linked);
    });

    test('returns immediately when already linked', () async {
      final log = <RecordedRequest>[];
      var polls = 0;
      final client = buildClient((req) async {
        polls++;
        return jsonResponse(requisitionJson(status: 'LN'));
      }, log: log);

      final linked = await client.waitForRequisitionLink(
        requisitionWith(status: RequisitionStatus.created),
      );

      expect(polls, 1);
      expect(linked.status, RequisitionStatus.linked);
    });
  });

  group('resource-object overloads delegate to id-based methods', () {
    test('getBalances(account) uses the account id', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(balancesJson),
        log: log,
      );
      final account = Account.fromJson(
        jsonDecode(accountJson) as Map<String, dynamic>,
      );

      await client.getBalances(account);

      expect(
        log.firstWhere((r) => !r.isToken).url.path,
        '/api/v2/accounts/${account.id}/balances/',
      );
    });

    test('getAccountDetails(account) uses the account id', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(accountDetailsJson),
        log: log,
      );
      final account = Account.fromJson(
        jsonDecode(accountJson) as Map<String, dynamic>,
      );

      await client.getAccountDetails(account);

      expect(
        log.firstWhere((r) => !r.isToken).url.path,
        '/api/v2/accounts/${account.id}/details/',
      );
    });

    test(
      'getTransactions(account) formats dates and uses the account id',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(
          (req) async => jsonResponse(transactionsJson),
          log: log,
        );
        final account = Account.fromJson(
          jsonDecode(accountJson) as Map<String, dynamic>,
        );

        await client.getTransactions(
          account,
          dateFrom: DateTime(2024, 6, 1),
          dateTo: DateTime(2024, 6, 30),
        );

        final req = log.firstWhere((r) => !r.isToken);
        expect(req.url.path, '/api/v2/accounts/${account.id}/transactions/');
        expect(req.url.queryParameters, {
          'date_from': '2024-06-01',
          'date_to': '2024-06-30',
        });
      },
    );
  });
}
