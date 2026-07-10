import 'dart:convert';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:test/test.dart';

import 'mock_support.dart';

/// The single non-token request in [log] (each test drives exactly one API
/// call, preceded by the automatic token fetch).
RecordedRequest apiRequest(List<RecordedRequest> log) =>
    log.firstWhere((r) => !r.isToken);

void main() {
  group('token lifecycle', () {
    test('fetches a token before the first API call', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionJson),
        log: log,
      );

      await client.getInstitutionById('SANDBOXFINANCE_SFIN0000');

      final tokenReq = log.firstWhere((r) => r.isToken);
      expect(log.first, tokenReq, reason: 'token must be fetched first');
      expect(tokenReq.method, 'POST');
      expect(tokenReq.url.toString(), '${baseUrl}token/new/');
      expect(tokenReq.headers['content-type'], contains('application/json'));
      expect(jsonDecode(tokenReq.body), {
        'secret_id': 'test-secret-id',
        'secret_key': 'test-secret-key',
      });
    });

    test('reuses a still-valid token across calls', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionJson),
        log: log,
      );

      await client.getInstitutionById('a');
      await client.getInstitutionById('b');

      expect(tokenRequestCount(log), 1);
    });

    test('re-requests a token that is within 30s of expiry', () async {
      final log = <RecordedRequest>[];
      // access_expires of 10s: the 30s safety margin always exceeds it, so
      // every call refreshes the token.
      final client = buildClient(
        (req) async => jsonResponse(institutionJson),
        log: log,
        tokenBody:
            '{"access":"A","access_expires":10,"refresh":"R","refresh_expires":20}',
      );

      await client.getInstitutionById('a');
      await client.getInstitutionById('b');

      expect(tokenRequestCount(log), 2);
    });

    test('sends the bearer token and accept header on API calls', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionJson),
        log: log,
      );

      await client.getInstitutionById('a');

      final req = apiRequest(log);
      expect(req.headers['authorization'], 'Bearer ACCESS');
      expect(req.headers['accept'], 'application/json');
    });
  });

  group('institution endpoints', () {
    test('getInstitutionMetadatas without a country omits the query', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionMetadataListJson),
        log: log,
      );

      final metadatas = await client.getInstitutionMetadatas();

      final req = apiRequest(log);
      expect(req.method, 'GET');
      expect(req.url.path, '/api/v2/institutions/');
      expect(req.url.hasQuery, isFalse);
      expect(metadatas, hasLength(2));
    });

    test('getInstitutionMetadatas filters by country code', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionMetadataListJson),
        log: log,
      );

      await client.getInstitutionMetadatas(
        country: GoCardlessCountryCode.germany,
      );

      final req = apiRequest(log);
      expect(req.url.path, '/api/v2/institutions/');
      expect(req.url.queryParameters, {'country': 'DE'});
    });

    test('getInstitutionById hits the by-id path', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionJson),
        log: log,
      );

      final institution = await client.getInstitutionById(
        'SANDBOXFINANCE_SFIN0000',
      );

      final req = apiRequest(log);
      expect(req.method, 'GET');
      expect(
        req.url.toString(),
        '${baseUrl}institutions/SANDBOXFINANCE_SFIN0000/',
      );
      expect(institution.name, 'Sandbox Finance');
    });

    test('getSandboxInstitution targets the sandbox id', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(institutionJson),
        log: log,
      );

      await client.getSandboxInstitution();

      expect(
        apiRequest(log).url.toString(),
        '${baseUrl}institutions/SANDBOXFINANCE_SFIN0000/',
      );
    });
  });

  group('agreement and requisition creation', () {
    test('createAgreementById posts the JSON agreement body', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(agreementJson),
        log: log,
      );

      await client.createAgreementById('INST', 90, 30, [
        InformationToAccess.balances,
        InformationToAccess.details,
      ]);

      final req = apiRequest(log);
      expect(req.method, 'POST');
      expect(req.url.toString(), '${baseUrl}agreements/enduser/');
      expect(req.headers['content-type'], contains('application/json'));
      expect(jsonDecode(req.body), {
        'institution_id': 'INST',
        'max_historical_days': 90,
        'access_valid_for_days': 30,
        'access_scope': ['balances', 'details'],
      });
    });

    test('createDefaultAgreementById sends only the institution id', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(agreementJson),
        log: log,
      );

      await client.createDefaultAgreementById('INST');

      expect(jsonDecode(apiRequest(log).body), {'institution_id': 'INST'});
    });

    test(
      'createRequisition uses the default redirect and agreement id',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(
          (req) async => jsonResponse(requisitionJson()),
          log: log,
        );
        final agreement = EndUserAgreement.fromJson(
          jsonDecode(agreementJson) as Map<String, dynamic>,
        );

        await client.createRequisition(agreement);

        final req = apiRequest(log);
        expect(req.method, 'POST');
        expect(req.url.toString(), '${baseUrl}requisitions/');
        final body = jsonDecode(req.body) as Map<String, dynamic>;
        expect(body['redirect'], 'https://www.gocardless.com');
        expect(body['institution_id'], 'SANDBOXFINANCE_SFIN0000');
        expect(body['agreement'], 'agr-123');
      },
    );

    test('createRequisition honours a custom redirect url', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(requisitionJson()),
        log: log,
      );
      final agreement = EndUserAgreement.fromJson(
        jsonDecode(agreementJson) as Map<String, dynamic>,
      );

      await client.createRequisition(
        agreement,
        redirectUrl: 'https://example.com/callback',
      );

      final body = jsonDecode(apiRequest(log).body) as Map<String, dynamic>;
      expect(body['redirect'], 'https://example.com/callback');
    });
  });

  group('account data endpoints', () {
    test('getAccountById targets the account path', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(accountJson),
        log: log,
      );

      final account = await client.getAccountById('acc-1');

      expect(apiRequest(log).url.toString(), '${baseUrl}accounts/acc-1/');
      expect(account.ownerName, 'John Doe');
    });

    test('getBalancesById targets the balances sub-resource', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(balancesJson),
        log: log,
      );

      final balances = await client.getBalancesById('acc-1');

      expect(
        apiRequest(log).url.toString(),
        '${baseUrl}accounts/acc-1/balances/',
      );
      expect(balances.balances, hasLength(2));
    });

    test('getAccountDetailsById targets the details sub-resource', () async {
      final log = <RecordedRequest>[];
      final client = buildClient(
        (req) async => jsonResponse(accountDetailsJson),
        log: log,
      );

      final details = await client.getAccountDetailsById('acc-1');

      expect(
        apiRequest(log).url.toString(),
        '${baseUrl}accounts/acc-1/details/',
      );
      expect(details.account.name, 'Main Account');
    });

    test(
      'getTransactionsById adds date_from/date_to when both are set',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(
          (req) async => jsonResponse(transactionsJson),
          log: log,
        );

        await client.getTransactionsById(
          'acc-1',
          dateFrom: DateTime(2024, 1, 5),
          dateTo: DateTime(2024, 2, 10),
        );

        final req = apiRequest(log);
        expect(req.url.path, '/api/v2/accounts/acc-1/transactions/');
        expect(req.url.queryParameters, {
          'date_from': '2024-01-05',
          'date_to': '2024-02-10',
        });
      },
    );

    test(
      'getTransactionsById omits the query when no dates are given',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(
          (req) async => jsonResponse(transactionsJson),
          log: log,
        );

        await client.getTransactionsById('acc-1');

        expect(apiRequest(log).url.hasQuery, isFalse);
      },
    );

    test(
      'getTransactionsById omits the query when only one date is given',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(
          (req) async => jsonResponse(transactionsJson),
          log: log,
        );

        await client.getTransactionsById(
          'acc-1',
          dateFrom: DateTime(2024, 1, 5),
        );

        expect(apiRequest(log).url.hasQuery, isFalse);
      },
    );
  });

  group('error propagation', () {
    test(
      'an error payload from any endpoint surfaces as GoCardlessException',
      () async {
        final log = <RecordedRequest>[];
        final client = buildClient(
          (req) async => jsonResponse(errorJson, status: 401),
          log: log,
        );

        expect(
          () => client.getInstitutionById('x'),
          throwsA(
            isA<GoCardlessException>().having(
              (e) => e.message,
              'message',
              'Invalid token: Token is invalid or expired (401)',
            ),
          ),
        );
      },
    );
  });
}
