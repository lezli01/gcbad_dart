// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
      accessToken: json['access'] as String,
      accessExpiresSeconds: json['access_expires'] as int,
      refreshToken: json['refresh'] as String,
      refreshExpiresSeconds: json['refresh_expires'] as int,
    );

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access': instance.accessToken,
      'access_expires': instance.accessExpiresSeconds,
      'refresh': instance.refreshToken,
      'refresh_expires': instance.refreshExpiresSeconds,
    };
