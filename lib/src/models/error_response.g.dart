// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ErrorResponse',
  json,
  ($checkedConvert) {
    final val = ErrorResponse(
      summary: $checkedConvert('summary', (v) => v as String?),
      detail: $checkedConvert('detail', (v) => v as String?),
      type: $checkedConvert('type', (v) => v as String?),
      statusCode: $checkedConvert('status_code', (v) => (v as num).toInt()),
      errorCode: $checkedConvert('_error_code', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
  fieldKeyMap: const {'statusCode': 'status_code', 'errorCode': '_error_code'},
);

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'summary': ?instance.summary,
      'detail': ?instance.detail,
      'type': ?instance.type,
      'status_code': instance.statusCode,
      '_error_code': ?instance.errorCode,
    };
