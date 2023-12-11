// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secretandkey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecretAndKey _$SecretAndKeyFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SecretAndKey',
      json,
      ($checkedConvert) {
        final val = SecretAndKey(
          secretId: $checkedConvert('secret_id', (v) => v as String),
          secretKey: $checkedConvert('secret_key', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {'secretId': 'secret_id', 'secretKey': 'secret_key'},
    );

Map<String, dynamic> _$SecretAndKeyToJson(SecretAndKey instance) =>
    <String, dynamic>{
      'secret_id': instance.secretId,
      'secret_key': instance.secretKey,
    };
