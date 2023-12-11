// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ErrorResponse',
      json,
      ($checkedConvert) {
        final val = ErrorResponse(
          summary: $checkedConvert('summary', (v) => v as String?),
          detail: $checkedConvert('detail', (v) => v as String?),
          type: $checkedConvert('type', (v) => v as String?),
          statusCode: $checkedConvert('status_code', (v) => v as int),
          errorCode: $checkedConvert('_error_code', (v) => v as int?),
        );
        return val;
      },
      fieldKeyMap: const {
        'statusCode': 'status_code',
        'errorCode': '_error_code'
      },
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('summary', instance.summary);
  writeNotNull('detail', instance.detail);
  writeNotNull('type', instance.type);
  val['status_code'] = instance.statusCode;
  writeNotNull('_error_code', instance.errorCode);
  return val;
}
