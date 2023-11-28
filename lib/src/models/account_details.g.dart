// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountDetails _$AccountDetailsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'AccountDetails',
      json,
      ($checkedConvert) {
        final val = AccountDetails(
          account: $checkedConvert(
              'account',
              (v) =>
                  AccountDetailsInternal.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {'details': 'account'},
    );

Map<String, dynamic> _$AccountDetailsToJson(AccountDetails instance) =>
    <String, dynamic>{
      'account': instance.account,
    };

AccountDetailsInternal _$AccountDetailsInternalFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AccountDetailsInternal',
      json,
      ($checkedConvert) {
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
          cashAccountType:
              $checkedConvert('cashAccountType', (v) => v as String?),
          status: $checkedConvert('status', (v) => v as String?),
          bic: $checkedConvert('bic', (v) => v as String?),
          linkedAccounts:
              $checkedConvert('linkedAccounts', (v) => v as String?),
          maskedPan: $checkedConvert('maskedPan', (v) => v as String?),
          usage: $checkedConvert('usage', (v) => v as String?),
          details: $checkedConvert('details', (v) => v as String?),
          ownerAddressUnstructured:
              $checkedConvert('ownerAddressUnstructured', (v) => v as String?),
          ownerAddressStructured: $checkedConvert(
              'ownerAddressStructured',
              (v) => v == null
                  ? null
                  : OwnerAddressStructured.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$AccountDetailsInternalToJson(
    AccountDetailsInternal instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resourceId', instance.resourceId);
  writeNotNull('iban', instance.iban);
  writeNotNull('bban', instance.bban);
  writeNotNull('msisdn', instance.msisdn);
  writeNotNull('currency', instance.currency);
  writeNotNull('ownerName', instance.ownerName);
  writeNotNull('name', instance.name);
  writeNotNull('displayName', instance.displayName);
  writeNotNull('product', instance.product);
  writeNotNull('cashAccountType', instance.cashAccountType);
  writeNotNull('status', instance.status);
  writeNotNull('bic', instance.bic);
  writeNotNull('linkedAccounts', instance.linkedAccounts);
  writeNotNull('maskedPan', instance.maskedPan);
  writeNotNull('usage', instance.usage);
  writeNotNull('details', instance.details);
  writeNotNull('ownerAddressUnstructured', instance.ownerAddressUnstructured);
  writeNotNull('ownerAddressStructured', instance.ownerAddressStructured);
  return val;
}

OwnerAddressStructured _$OwnerAddressStructuredFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'OwnerAddressStructured',
      json,
      ($checkedConvert) {
        final val = OwnerAddressStructured(
          streetName: $checkedConvert('streetName', (v) => v as String?),
          buildingNumber:
              $checkedConvert('buildingNumber', (v) => v as String?),
          townName: $checkedConvert('townName', (v) => v as String?),
          postCode: $checkedConvert('postCode', (v) => v as String?),
          country: $checkedConvert('country', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$OwnerAddressStructuredToJson(
    OwnerAddressStructured instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('streetName', instance.streetName);
  writeNotNull('buildingNumber', instance.buildingNumber);
  writeNotNull('townName', instance.townName);
  writeNotNull('postCode', instance.postCode);
  writeNotNull('country', instance.country);
  return val;
}
