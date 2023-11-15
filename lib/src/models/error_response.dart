import 'package:gcbad_dart/src/gocardless_exception.dart';
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
      return GoCardlessException(message: '$summary: $detail ($statusCode)');
    }

    if (summary != null) {
      return GoCardlessException(message: '$summary ($statusCode)');
    }

    if (detail != null) {
      return GoCardlessException(message: '$detail ($statusCode)');
    }

    return GoCardlessException(
        message: 'Error during communication ($statusCode)');
  }

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
