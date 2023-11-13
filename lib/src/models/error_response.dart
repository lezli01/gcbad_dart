import 'package:gcbad_dart/src/gcbad_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  @JsonKey(name: 'summary')
  final String? summary;
  @JsonKey(name: 'detail')
  final String? detail;
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'status_code')
  final int statusCode;
  @JsonKey(name: '_error_code')
  final int? errorCode;

  ErrorResponse(
      {required this.summary,
      required this.detail,
      required this.type,
      required this.statusCode,
      required this.errorCode});

  get exception {
    if (summary != null && detail != null) {
      return GCBADException(message: '$summary: $detail ($statusCode)');
    }

    if (summary != null) {
      return GCBADException(message: '$summary ($statusCode)');
    }

    if (detail != null) {
      return GCBADException(message: '$detail ($statusCode)');
    }

    return GCBADException(message: 'Error during communication ($statusCode)');
  }

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
