// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Token',
  json,
  ($checkedConvert) {
    final val = Token(
      accessToken: $checkedConvert('access', (v) => v as String),
      accessExpiresSeconds: $checkedConvert(
        'access_expires',
        (v) => (v as num).toInt(),
      ),
      refreshToken: $checkedConvert('refresh', (v) => v as String),
      refreshExpiresSeconds: $checkedConvert(
        'refresh_expires',
        (v) => (v as num).toInt(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'accessToken': 'access',
    'accessExpiresSeconds': 'access_expires',
    'refreshToken': 'refresh',
    'refreshExpiresSeconds': 'refresh_expires',
  },
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'access': instance.accessToken,
  'access_expires': instance.accessExpiresSeconds,
  'refresh': instance.refreshToken,
  'refresh_expires': instance.refreshExpiresSeconds,
};
