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
          details: $checkedConvert(
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
      'account': instance.details,
    };

AccountDetailsInternal _$AccountDetailsInternalFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'AccountDetailsInternal',
      json,
      ($checkedConvert) {
        final val = AccountDetailsInternal(
          name: $checkedConvert('name', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$AccountDetailsInternalToJson(
        AccountDetailsInternal instance) =>
    <String, dynamic>{
      'name': instance.name,
    };
