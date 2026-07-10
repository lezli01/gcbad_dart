// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Account',
  json,
  ($checkedConvert) {
    final val = Account(
      id: $checkedConvert('id', (v) => v as String),
      created: $checkedConvert('created', (v) => v as String?),
      lastAccessed: $checkedConvert('last_accessed', (v) => v as String?),
      iban: $checkedConvert('iban', (v) => v as String?),
      institutionId: $checkedConvert('institution_id', (v) => v as String),
      status: $checkedConvert('status', (v) => v as String?),
      ownerName: $checkedConvert('owner_name', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'lastAccessed': 'last_accessed',
    'institutionId': 'institution_id',
    'ownerName': 'owner_name',
  },
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'id': instance.id,
  'created': ?instance.created,
  'last_accessed': ?instance.lastAccessed,
  'iban': ?instance.iban,
  'institution_id': instance.institutionId,
  'status': ?instance.status,
  'owner_name': ?instance.ownerName,
};
