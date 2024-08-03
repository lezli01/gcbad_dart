// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Institution _$InstitutionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Institution',
      json,
      ($checkedConvert) {
        final val = Institution(
          supportedFeatures: $checkedConvert(
              'supported_features',
              (v) => (v as List<dynamic>)
                  .map((e) => $enumDecode(_$InstitutionFeatureEnumMap, e))
                  .toList()),
          identificationCodes: $checkedConvert('identification_codes',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          bic: $checkedConvert('bic', (v) => v as String?),
          transactionTotalDays:
              $checkedConvert('transaction_total_days', (v) => v as String?),
          countries: $checkedConvert(
              'countries',
              (v) => (v as List<dynamic>)
                  .map((e) => $enumDecode(_$GoCardlessCountryCodeEnumMap, e))
                  .toList()),
          logo: $checkedConvert('logo', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'supportedFeatures': 'supported_features',
        'identificationCodes': 'identification_codes',
        'transactionTotalDays': 'transaction_total_days'
      },
    );

Map<String, dynamic> _$InstitutionToJson(Institution instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('bic', instance.bic);
  writeNotNull('transaction_total_days', instance.transactionTotalDays);
  val['countries'] = instance.countries
      .map((e) => _$GoCardlessCountryCodeEnumMap[e]!)
      .toList();
  val['logo'] = instance.logo;
  val['supported_features'] = instance.supportedFeatures
      .map((e) => _$InstitutionFeatureEnumMap[e]!)
      .toList();
  val['identification_codes'] = instance.identificationCodes;
  return val;
}

const _$InstitutionFeatureEnumMap = {
  InstitutionFeature.submitPayment: 'submit_payment',
  InstitutionFeature.payments: 'payments',
  InstitutionFeature.pendingTransactions: 'pending_transactions',
  InstitutionFeature.readDebtorAccount: 'read_debtor_account',
  InstitutionFeature.readRefundAccount: 'read_refund_account',
  InstitutionFeature.cardAccounts: 'card_accounts',
  InstitutionFeature.privateAccounts: 'private_accounts',
  InstitutionFeature.businessAccounts: 'business_accounts',
  InstitutionFeature.corporateAccounts: 'corporate_accounts',
  InstitutionFeature.ssnVerification: 'ssn_verification',
  InstitutionFeature.accountSelection: 'account_selection',
};

const _$GoCardlessCountryCodeEnumMap = {
  GoCardlessCountryCode.invalid: 'XX',
  GoCardlessCountryCode.austria: 'AT',
  GoCardlessCountryCode.belgium: 'BE',
  GoCardlessCountryCode.bulgaria: 'BG',
  GoCardlessCountryCode.croatia: 'HR',
  GoCardlessCountryCode.cyprus: 'CY',
  GoCardlessCountryCode.czechia: 'CZ',
  GoCardlessCountryCode.denmark: 'DK',
  GoCardlessCountryCode.estonia: 'EE',
  GoCardlessCountryCode.finland: 'FI',
  GoCardlessCountryCode.france: 'FR',
  GoCardlessCountryCode.germany: 'DE',
  GoCardlessCountryCode.greece: 'GR',
  GoCardlessCountryCode.hungary: 'HU',
  GoCardlessCountryCode.iceland: 'IS',
  GoCardlessCountryCode.ireland: 'IE',
  GoCardlessCountryCode.italy: 'IT',
  GoCardlessCountryCode.latvia: 'LV',
  GoCardlessCountryCode.liechtenstein: 'LI',
  GoCardlessCountryCode.lithuania: 'LT',
  GoCardlessCountryCode.luxembourg: 'LU',
  GoCardlessCountryCode.malta: 'MT',
  GoCardlessCountryCode.netherlands: 'NL',
  GoCardlessCountryCode.norway: 'NO',
  GoCardlessCountryCode.poland: 'PL',
  GoCardlessCountryCode.portugal: 'PT',
  GoCardlessCountryCode.romania: 'RO',
  GoCardlessCountryCode.slovakia: 'SK',
  GoCardlessCountryCode.slovenia: 'SI',
  GoCardlessCountryCode.spain: 'ES',
  GoCardlessCountryCode.sweden: 'SE',
  GoCardlessCountryCode.unitedKingdom: 'GB',
};
