@Tags(['live'])
@Timeout(Duration(minutes: 5))
library;

import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:test/test.dart';

import 'sandbox_client.dart';

/// The GoCardless sandbox institution these tests target.
const sandboxInstitutionId = 'SANDBOXFINANCE_SFIN0000';

// Fixtures the sandbox seeds for a linked SANDBOXFINANCE_SFIN0000 requisition.
// Centralized so a sandbox re-seed is a one-line change rather than a
// scattered edit across the account-data group.
const johnDoe = 'John Doe';
const janeDoe = 'Jane Doe';
const sandboxOwnerNames = [johnDoe, janeDoe];
const sandboxAccountCount = 2;

/// Canonical crockford-base32 ULID shape used by GoCardless `resourceId`s.
final ulidPattern = RegExp(r'^[0-9A-HJKMNP-TV-Z]{26}$');

/// Sandbox IBANs are Greenland-format: `GL` followed by 16 digits. The digits
/// are randomly generated per link, so only the shape is stable.
final glIbanPattern = RegExp(r'^GL[0-9]{16}$');

/// Returns the account owned by [ownerName], failing with a clear message
/// (rather than a bare `StateError`) if the sandbox fixture ever changes.
Account accountOwnedBy(List<Account> accounts, String ownerName) =>
    accounts.firstWhere(
      (a) => a.ownerName == ownerName,
      orElse: () => fail('no sandbox account owned by "$ownerName"'),
    );

void main() {
  final secretId = Platform.environment['GCBAD_ID'];
  final secretKey = Platform.environment['GCBAD_KEY'];
  final credentialsMissing =
      secretId == null ||
      secretId.isEmpty ||
      secretKey == null ||
      secretKey.isEmpty;

  // Skip (rather than crash) when credentials are absent, so a plain
  // `dart test` without sandbox credentials reports these as skipped.
  final skip = credentialsMissing
      ? 'Set GCBAD_ID and GCBAD_KEY to run the live sandbox integration tests'
      : false;

  // -------------------------------------------------------------------------
  // Cheap read/create endpoints — no bank-consent flow required, so they share
  // a single client and never pay the puppeteer cost.
  // -------------------------------------------------------------------------
  group('sandbox API (no consent flow)', () {
    late GoCardlessBankAccountDataClient client;

    setUpAll(() {
      client = GoCardlessBankAccountDataClient(
        secretId: secretId!,
        secretKey: secretKey!,
      );
    });
    tearDownAll(() => client.close());

    group('institution discovery', () {
      test('getSandboxInstitution / getInstitutionById resolve the sandbox '
          'institution', () async {
        final sandbox = await client.getSandboxInstitution();
        expect(sandbox.id, sandboxInstitutionId);
        expect(sandbox.name, isNotEmpty);
        expect(
          int.tryParse(sandbox.transactionTotalDays ?? ''),
          isNotNull,
          reason: 'SandboxClient parses this into max_historical_days',
        );

        final byId = await client.getInstitutionById(sandboxInstitutionId);
        expect(byId.id, sandbox.id);
        expect(byId.name, sandbox.name);
      });

      test('getInstitutionMetadatas filters by country', () async {
        final metadatas = await client.getInstitutionMetadatas(
          country: GoCardlessCountryCode.unitedKingdom,
        );

        expect(metadatas, isNotEmpty);
        for (final metadata in metadatas) {
          expect(metadata.id, isNotEmpty);
          expect(metadata.name, isNotEmpty);
          // Proves the filter is actually applied — every returned institution
          // must serve the requested country, not just be a non-empty list.
          expect(
            metadata.countries,
            contains(GoCardlessCountryCode.unitedKingdom),
          );
        }
      });

      test(
        'getInstitutionMetadatas without a country returns a list',
        () async {
          expect(await client.getInstitutionMetadatas(), isNotEmpty);
        },
      );

      test('getInstitutionByMetadata hydrates the full institution', () async {
        final metadatas = await client.getInstitutionMetadatas(
          country: GoCardlessCountryCode.unitedKingdom,
        );
        final first = metadatas.first;

        final institution = await client.getInstitutionByMetadata(first);
        expect(institution.id, first.id);
        expect(institution.name, first.name);
      });
    });

    group('agreement creation', () {
      test('createAgreementById echoes the requested scope', () async {
        const scope = [
          InformationToAccess.balances,
          InformationToAccess.details,
          InformationToAccess.transactions,
        ];

        final agreement = await client.createAgreementById(
          sandboxInstitutionId,
          90,
          90,
          scope,
        );

        expect(agreement.id, isNotNull);
        expect(agreement.institutionId, sandboxInstitutionId);
        expect(agreement.maxHistoricalDays, 90);
        expect(agreement.accessScope, containsAll(scope));
      });

      test('createDefaultAgreementById returns a valid agreement', () async {
        final agreement = await client.createDefaultAgreementById(
          sandboxInstitutionId,
        );

        expect(agreement.id, isNotNull);
        expect(agreement.institutionId, sandboxInstitutionId);
      });

      test('createDefaultAgreement accepts institution metadata', () async {
        final institution = await client.getSandboxInstitution();

        final agreement = await client.createDefaultAgreement(institution);

        expect(agreement.id, isNotNull);
        expect(agreement.institutionId, sandboxInstitutionId);
      });
    });

    group('requisition creation', () {
      // Creating a requisition does not require the consent flow; only linking
      // it does. This covers the fresh-requisition shape and the explicit
      // redirectUrl argument variant that SandboxClient never exercises.
      test(
        'createRequisition returns a fresh requisition echoing the redirect',
        () async {
          final agreement = await client.createDefaultAgreementById(
            sandboxInstitutionId,
          );
          const redirectUrl = 'https://example.com/callback';

          final requisition = await client.createRequisition(
            agreement,
            redirectUrl: redirectUrl,
          );

          expect(requisition.id, isNotEmpty);
          expect(requisition.status, RequisitionStatus.created);
          expect(requisition.link, isNotEmpty);
          expect(requisition.redirect, redirectUrl);
          expect(requisition.institutionId, sandboxInstitutionId);
        },
      );
    });

    group('error handling', () {
      // Only the exception TYPE is asserted: the 400-vs-404 split and the
      // human-readable message text are not contractual, and the numeric
      // status code is not exposed on GoCardlessException.
      test('unknown institution id throws GoCardlessException', () async {
        await expectLater(
          client.getInstitutionById('THIS_INSTITUTION_DOES_NOT_EXIST'),
          throwsA(isA<GoCardlessException>()),
        );
      });

      test('nonexistent requisition id throws GoCardlessException', () async {
        await expectLater(
          client.getRequisition('00000000-0000-0000-0000-000000000000'),
          throwsA(isA<GoCardlessException>()),
        );
      });

      test('a bad account id throws GoCardlessException on every accounts '
          'endpoint', () async {
        const badId = 'not-a-valid-uuid';

        await expectLater(
          client.getAccountById(badId),
          throwsA(isA<GoCardlessException>()),
        );
        await expectLater(
          client.getBalancesById(badId),
          throwsA(isA<GoCardlessException>()),
        );
        await expectLater(
          client.getAccountDetailsById(badId),
          throwsA(isA<GoCardlessException>()),
        );
        await expectLater(
          client.getTransactionsById(badId),
          throwsA(isA<GoCardlessException>()),
        );
      });
    });
  }, skip: skip);

  // -------------------------------------------------------------------------
  // Lifecycle: close() is otherwise never exercised.
  // -------------------------------------------------------------------------
  group('lifecycle', () {
    test('close() releases a client without error', () async {
      final client = GoCardlessBankAccountDataClient(
        secretId: secretId!,
        secretKey: secretKey!,
      );

      // Force a token fetch + one request so there is a live connection pool
      // to release.
      final institution = await client.getSandboxInstitution();
      expect(institution.id, sandboxInstitutionId);

      expect(client.close, returnsNormally);
    });
  }, skip: skip);

  // -------------------------------------------------------------------------
  // Account data — requires a linked requisition, so it pays the one-time
  // puppeteer consent flow via SandboxClient (shared across the group).
  // -------------------------------------------------------------------------
  group('account data (requires linked requisition)', () {
    late GoCardlessBankAccountDataClient client;
    late Requisition requisition;

    setUpAll(() async {
      (client, requisition) = await SandboxClient().waitForRequisition();
    });
    tearDownAll(() => client.close());

    test('the requisition is linked with two accounts', () async {
      final fetched = await client.getRequisition(requisition.id);

      expect(fetched.status, RequisitionStatus.linked);
      expect(fetched.institutionId, sandboxInstitutionId);
      expect(fetched.accounts, hasLength(sandboxAccountCount));
    });

    test(
      'waitForRequisitionLinkById returns an already-linked requisition',
      () async {
        final linked = await client.waitForRequisitionLinkById(requisition.id);
        expect(linked.status, RequisitionStatus.linked);
      },
    );

    test('getAccounts / getAccountsById expose John and Jane', () async {
      // GoCardless does not guarantee account ordering, so assert on the set
      // of owners rather than positional indices.
      final accounts = await client.getAccounts(requisition);
      expect(accounts, hasLength(sandboxAccountCount));
      expect(accounts.map((a) => a.ownerName), containsAll(sandboxOwnerNames));
      for (final account in accounts) {
        expect(account.id, isNotEmpty);
        expect(account.institutionId, sandboxInstitutionId);
      }

      final byRequisitionId = await client.getAccountsById(requisition.id);
      expect(byRequisitionId, hasLength(sandboxAccountCount));
      expect(
        byRequisitionId.map((a) => a.ownerName),
        containsAll(sandboxOwnerNames),
      );
    });

    test('getAccountById returns a single account by id', () async {
      final id = requisition.accounts!.first;

      final account = await client.getAccountById(id);
      expect(account.id, id);
      expect(account.institutionId, sandboxInstitutionId);
    });

    test('getBalances / getBalancesById return EUR balances', () async {
      final accounts = await client.getAccounts(requisition);

      for (final account in accounts) {
        for (final balances in [
          await client.getBalances(account),
          await client.getBalancesById(account.id),
        ]) {
          expect(balances.balances, isNotEmpty);
          for (final balance in balances.balances) {
            expect(balance.balanceAmount.currency, 'EUR');
            expect(
              double.tryParse(balance.balanceAmount.amount),
              isNotNull,
              reason: 'amount must be a numeric string',
            );
          }
        }
      }
    });

    test(
      'getAccountDetails / getAccountDetailsById expose stable fixtures',
      () async {
        final accounts = await client.getAccounts(requisition);
        final john = accountOwnedBy(accounts, johnDoe);
        final jane = accountOwnedBy(accounts, janeDoe);

        final johnDetails = await client.getAccountDetails(john);
        // Exercise the by-id overload for the second account.
        final janeDetails = await client.getAccountDetailsById(jane.id);

        for (final entry in {
          johnDoe: johnDetails,
          janeDoe: janeDetails,
        }.entries) {
          final details = entry.value.account;
          expect(details.ownerName, entry.key);
          expect(details.resourceId, matches(ulidPattern));
          expect(details.iban, matches(glIbanPattern));
          expect(details.currency, 'EUR');
          expect(details.name, 'Main Account');
          expect(details.product, 'Checkings');
          expect(details.cashAccountType, 'CACC');
        }

        // The two accounts are distinct fixtures.
        expect(
          johnDetails.account.resourceId,
          isNot(janeDetails.account.resourceId),
        );
      },
    );

    test(
      'getTransactions with a date range returns booked transactions',
      () async {
        final accounts = await client.getAccounts(requisition);
        final account = accountOwnedBy(accounts, johnDoe);

        // The sandbox generates transactions relative to the current date, so
        // query a trailing window rather than a fixed historical range. Use a
        // narrow window in UTC: it stays well inside any plausible agreement
        // max_historical_days cap and avoids local-vs-UTC boundary drift, while
        // the sandbox still seeds recent booked entries within it.
        final now = DateTime.now().toUtc();
        final transactions = await client.getTransactions(
          account,
          dateFrom: now.subtract(const Duration(days: 14)),
          dateTo: now,
        );

        expect(transactions.transactions.booked, isNotEmpty);
        for (final transaction in transactions.transactions.booked) {
          expect(transaction.transactionAmount.currency, 'EUR');
          expect(
            double.tryParse(transaction.transactionAmount.amount),
            isNotNull,
            reason: 'amount must be a numeric string',
          );
        }
      },
    );

    test(
      'getTransactions without a date range returns booked transactions',
      () async {
        final accounts = await client.getAccounts(requisition);
        final account = accountOwnedBy(accounts, johnDoe);

        // Exercises the no-date-range branch (and dateToStringFormat's null
        // path): the client sends no date_from/date_to and the API returns the
        // full available window.
        final transactions = await client.getTransactions(account);

        expect(transactions.transactions.booked, isNotEmpty);
      },
    );
  }, skip: skip);
}
