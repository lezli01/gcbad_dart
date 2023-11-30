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

  static GoCardlessException createException(dynamic json) {
    var message = 'Unknown error occurred during communication.';

    final error = json as Map<String, dynamic>;

    final summary = error['summary'] as List<dynamic>;
    final detail = error['detail'] as List<dynamic>;
    final statusCode = error['status_code'] as int;

    if (summary.isNotEmpty && detail.isNotEmpty) {
      message = '${summary[0]}: ${detail[0]} ($statusCode)';
    }

    return GoCardlessException(message: message);
  }

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
