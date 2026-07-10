// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDetails _$AccountDetailsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountDetails', json, ($checkedConvert) {
      final val = AccountDetails(
        account: $checkedConvert(
          'account',
          (v) => AccountDetailsInternal.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$AccountDetailsToJson(AccountDetails instance) =>
    <String, dynamic>{'account': instance.account};

AccountDetailsInternal _$AccountDetailsInternalFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('AccountDetailsInternal', json, ($checkedConvert) {
  final val = AccountDetailsInternal(
    resourceId: $checkedConvert('resourceId', (v) => v as String?),
    iban: $checkedConvert('iban', (v) => v as String?),
    bban: $checkedConvert('bban', (v) => v as String?),
    msisdn: $checkedConvert('msisdn', (v) => v as String?),
    currency: $checkedConvert('currency', (v) => v as String?),
    ownerName: $checkedConvert('ownerName', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String?),
    displayName: $checkedConvert('displayName', (v) => v as String?),
    product: $checkedConvert('product', (v) => v as String?),
    cashAccountType: $checkedConvert('cashAccountType', (v) => v as String?),
    status: $checkedConvert('status', (v) => v as String?),
    bic: $checkedConvert('bic', (v) => v as String?),
    linkedAccounts: $checkedConvert('linkedAccounts', (v) => v as String?),
    maskedPan: $checkedConvert('maskedPan', (v) => v as String?),
    usage: $checkedConvert('usage', (v) => v as String?),
    details: $checkedConvert('details', (v) => v as String?),
    ownerAddressUnstructured: $checkedConvert(
      'ownerAddressUnstructured',
      (v) => v as String?,
    ),
    ownerAddressStructured: $checkedConvert(
      'ownerAddressStructured',
      (v) => v == null
          ? null
          : OwnerAddressStructured.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$AccountDetailsInternalToJson(
  AccountDetailsInternal instance,
) => <String, dynamic>{
  'resourceId': ?instance.resourceId,
  'iban': ?instance.iban,
  'bban': ?instance.bban,
  'msisdn': ?instance.msisdn,
  'currency': ?instance.currency,
  'ownerName': ?instance.ownerName,
  'name': ?instance.name,
  'displayName': ?instance.displayName,
  'product': ?instance.product,
  'cashAccountType': ?instance.cashAccountType,
  'status': ?instance.status,
  'bic': ?instance.bic,
  'linkedAccounts': ?instance.linkedAccounts,
  'maskedPan': ?instance.maskedPan,
  'usage': ?instance.usage,
  'details': ?instance.details,
  'ownerAddressUnstructured': ?instance.ownerAddressUnstructured,
  'ownerAddressStructured': ?instance.ownerAddressStructured,
};

OwnerAddressStructured _$OwnerAddressStructuredFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('OwnerAddressStructured', json, ($checkedConvert) {
  final val = OwnerAddressStructured(
    streetName: $checkedConvert('streetName', (v) => v as String?),
    buildingNumber: $checkedConvert('buildingNumber', (v) => v as String?),
    townName: $checkedConvert('townName', (v) => v as String?),
    postCode: $checkedConvert('postCode', (v) => v as String?),
    country: $checkedConvert('country', (v) => v as String?),
  );
  return val;
});

Map<String, dynamic> _$OwnerAddressStructuredToJson(
  OwnerAddressStructured instance,
) => <String, dynamic>{
  'streetName': ?instance.streetName,
  'buildingNumber': ?instance.buildingNumber,
  'townName': ?instance.townName,
  'postCode': ?instance.postCode,
  'country': ?instance.country,
};
