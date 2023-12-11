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

    String? summaryText;
    String? detailText;
    int? statusCodeValue;

    if (json is Map<String, dynamic>) {
      final summary = json['summary'];
      final detail = json['detail'];
      final statusCode = json['status_code'];

      if (summary is List<dynamic> &&
          summary.isNotEmpty &&
          summary[0] is String) {
        summaryText = summary[0];
      }

      if (detail is List<dynamic> && detail.isNotEmpty && detail[0] is String) {
        detailText = detail[0];
      }

      if (statusCode is int) {
        statusCodeValue = statusCode;
      }
    }

    if (summaryText != null) {
      message = summaryText;

      if (detailText != null) {
        message = '$message: $detailText';
      }
    } else if (detailText != null) {
      message = detailText;
    }

    if (statusCodeValue != null) {
      message = '$message ($statusCodeValue)';
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
