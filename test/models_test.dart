import 'dart:convert';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:test/test.dart';

import 'mock_support.dart';

T decode<T>(String json, T Function(Map<String, dynamic>) fromJson) =>
    fromJson(jsonDecode(json) as Map<String, dynamic>);

void main() {
  group('Token', () {
    test('maps wire field names and derives durations', () {
      final token = decode(tokenJson, Token.fromJson);

      expect(token.accessToken, 'ACCESS');
      expect(token.accessExpiresSeconds, 86400);
      expect(token.refreshToken, 'REFRESH');
      expect(token.refreshExpiresSeconds, 2592000);
      expect(token.accessExpires, const Duration(seconds: 86400));
      expect(token.refreshExpires, const Duration(seconds: 2592000));
    });
  });

  group('SecretAndKey', () {
    test('serialises to the snake_case wire shape', () {
      final json = SecretAndKey(
        secretId: 'the-id',
        secretKey: 'the-key',
      ).toJson();

      expect(json, {'secret_id': 'the-id', 'secret_key': 'the-key'});
    });
  });

  group('RequisitionStatus enum mapping', () {
    test('decodes every wire code to its status', () {
      const pairs = {
        'CR': RequisitionStatus.created,
        'GC': RequisitionStatus.givingConsent,
        'UA': RequisitionStatus.undergoingAuthentication,
        'RJ': RequisitionStatus.rejected,
        'SA': RequisitionStatus.selectingAccounts,
        'GA': RequisitionStatus.grantingAccess,
        'LN': RequisitionStatus.linked,
        'EX': RequisitionStatus.expired,
      };

      pairs.forEach((code, status) {
        final requisition = decode(
          requisitionJson(status: code),
          Requisition.fromJson,
        );
        expect(requisition.status, status, reason: 'wire code $code');
      });
    });

    test('linked status and accounts survive a round-trip', () {
      final requisition = decode(
        requisitionJson(status: 'LN', accounts: ['a', 'b']),
        Requisition.fromJson,
      );

      expect(requisition.status, RequisitionStatus.linked);
      expect(requisition.accounts, ['a', 'b']);
      expect(requisition.toJson()['status'], 'LN');
    });
  });

  group('InformationToAccess / InstitutionFeature enum mapping', () {
    test('agreement access scope decodes to enum values', () {
      final agreement = decode(agreementJson, EndUserAgreement.fromJson);

      expect(agreement.accessScope, [
        InformationToAccess.balances,
        InformationToAccess.details,
        InformationToAccess.transactions,
      ]);
    });

    test('institution features decode from their codes', () {
      final institution = decode(institutionJson, Institution.fromJson);

      expect(institution.supportedFeatures, [
        InstitutionFeature.accountSelection,
        InstitutionFeature.businessAccounts,
      ]);
    });
  });

  group('GoCardlessCountryCode enum mapping', () {
    test('decodes country codes on institution metadata', () {
      final metadatas = (jsonDecode(institutionMetadataListJson) as List)
          .map((e) => InstitutionMetadata.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(metadatas[0].countries, [GoCardlessCountryCode.netherlands]);
      expect(metadatas[1].countries, [
        GoCardlessCountryCode.unitedKingdom,
        GoCardlessCountryCode.ireland,
        GoCardlessCountryCode.france,
      ]);
    });

    test('serialises back to two-letter codes', () {
      final json = InstitutionMetadata(
        id: 'x',
        name: 'X Bank',
        bic: null,
        transactionTotalDays: null,
        countries: [
          GoCardlessCountryCode.germany,
          GoCardlessCountryCode.invalid,
        ],
        logo: 'logo',
      ).toJson();

      expect(json['countries'], ['DE', 'XX']);
    });
  });

  group('Institution inheritance', () {
    test('exposes both base and derived fields', () {
      final institution = decode(institutionJson, Institution.fromJson);

      // Inherited from InstitutionMetadata.
      expect(institution.id, 'SANDBOXFINANCE_SFIN0000');
      expect(institution.name, 'Sandbox Finance');
      expect(institution.bic, 'SFIN0000');
      expect(institution.transactionTotalDays, '90');
      // Declared on Institution.
      expect(institution.identificationCodes, isEmpty);
      expect(institution.supportedFeatures, hasLength(2));
    });

    test('toJson emits base + derived fields', () {
      final json = decode(institutionJson, Institution.fromJson).toJson();

      expect(json['id'], 'SANDBOXFINANCE_SFIN0000');
      expect(json['countries'], ['XX']);
      expect(json['supported_features'], [
        'account_selection',
        'business_accounts',
      ]);
      expect(json['identification_codes'], isEmpty);
    });
  });

  group('enum drift tolerance', () {
    // GoCardless adds new feature and country codes over time. Deserialization
    // must map unmodeled values to a fallback rather than throwing (which the
    // HTTP layer would otherwise surface as an opaque GoCardlessException),
    // breaking getInstitutionById/getInstitutionMetadatas for real data.
    test('an unmodeled supported_features code decodes to unknown', () {
      final institution = decode(
        '{"id":"X","name":"X Bank","bic":null,"transaction_total_days":null,'
        '"countries":["GB"],"logo":"logo",'
        '"supported_features":["account_selection","reconfirmation_of_consent"],'
        '"identification_codes":[]}',
        Institution.fromJson,
      );

      expect(institution.supportedFeatures, [
        InstitutionFeature.accountSelection,
        InstitutionFeature.unknown,
      ]);
    });

    test('an unmodeled country code decodes to invalid', () {
      final metadata = decode(
        '{"id":"X","name":"X Bank","bic":null,"transaction_total_days":null,'
        '"countries":["GB","ZZ"],"logo":"logo"}',
        InstitutionMetadata.fromJson,
      );

      expect(metadata.countries, [
        GoCardlessCountryCode.unitedKingdom,
        GoCardlessCountryCode.invalid,
      ]);
    });

    test('a missing logo decodes to null rather than failing', () {
      final metadata = decode(
        '{"id":"X","name":"X Bank","bic":null,"transaction_total_days":null,'
        '"countries":["GB"]}',
        InstitutionMetadata.fromJson,
      );

      expect(metadata.logo, isNull);
      expect(metadata.countries, [GoCardlessCountryCode.unitedKingdom]);
    });
  });

  group('null omission (include_if_null: false)', () {
    test('Account drops null members but keeps required ones', () {
      final json = Account(
        id: 'acc-1',
        created: null,
        lastAccessed: null,
        iban: null,
        institutionId: 'INST',
        status: null,
        ownerName: null,
      ).toJson();

      expect(json, {'id': 'acc-1', 'institution_id': 'INST'});
    });
  });

  group('EndUserAgreementRequest', () {
    test('withDefaults omits the optional null fields', () {
      final json = EndUserAgreementRequest.withDefaults(
        institutionId: 'INST',
      ).toJson();

      expect(json, {'institution_id': 'INST'});
    });

    test('full request serialises scope as codes', () {
      final json = EndUserAgreementRequest(
        institutionId: 'INST',
        maxHistoricalDays: 90,
        accessValidForDays: 30,
        accessScope: [
          InformationToAccess.balances,
          InformationToAccess.transactions,
        ],
      ).toJson();

      expect(json, {
        'institution_id': 'INST',
        'max_historical_days': 90,
        'access_valid_for_days': 30,
        'access_scope': ['balances', 'transactions'],
      });
    });
  });

  group('RequisitionRequest', () {
    test('always emits redirect (includeIfNull) but drops other nulls', () {
      final json = RequisitionRequest.withDefaults(
        redirectUrl: null,
        institutionId: 'INST',
      ).toJson();

      // redirect is annotated includeIfNull: true, so it survives as null.
      expect(json.containsKey('redirect'), isTrue);
      expect(json['redirect'], isNull);
      expect(json['institution_id'], 'INST');
      // Everything else is null and must be omitted.
      expect(json.containsKey('agreement'), isFalse);
      expect(json.containsKey('reference'), isFalse);
      expect(json.containsKey('account_selection'), isFalse);
    });

    test('carries through the agreement id and redirect when set', () {
      final json = RequisitionRequest.withDefaults(
        redirectUrl: 'https://example.com/cb',
        institutionId: 'INST',
        agreementId: 'agr-1',
      ).toJson();

      expect(json['redirect'], 'https://example.com/cb');
      expect(json['agreement'], 'agr-1');
    });
  });

  group('nested collection models', () {
    test('Balances parses nested amounts', () {
      final balances = decode(balancesJson, Balances.fromJson);

      expect(balances.balances, hasLength(2));
      expect(balances.balances[0].balanceAmount.amount, '1913.12');
      expect(balances.balances[0].balanceAmount.currency, 'EUR');
      expect(balances.balances[0].balanceType, 'interimAvailable');
      expect(balances.balances[1].creditLimitIncluded, isFalse);
    });

    test('AccountDetails parses the nested structured owner address', () {
      final details = decode(accountDetailsJson, AccountDetails.fromJson);

      expect(details.account.resourceId, '01F3NS4YV94RA29YCH8R0F6BMF');
      expect(details.account.cashAccountType, 'CACC');
      expect(details.account.ownerAddressStructured?.townName, 'Nuuk');
      expect(details.account.ownerAddressStructured?.country, 'GL');
    });

    test('Transactions parses booked entries and an empty pending list', () {
      final transactions = decode(transactionsJson, Transactions.fromJson);

      expect(transactions.transactions.pending, isEmpty);
      expect(transactions.transactions.booked, hasLength(1));

      final booked = transactions.transactions.booked.single;
      expect(booked.transactionId, 't1');
      expect(booked.transactionAmount.amount, '-15.00');
      expect(booked.transactionAmount.currency, 'EUR');
      expect(booked.remittanceInformationUnstructured, 'Payment to shop');
    });
  });
}
