// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secretandkey.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecretAndKey _$SecretAndKeyFromJson(Map<String, dynamic> json) => SecretAndKey(
      secretId: json['secret_id'] as String,
      secretKey: json['secret_key'] as String,
    );

Map<String, dynamic> _$SecretAndKeyToJson(SecretAndKey instance) =>
    <String, dynamic>{
      'secret_id': instance.secretId,
      'secret_key': instance.secretKey,
    };
