import 'dart:convert';

import 'package:gcbad_dart/src/gocardless_exception.dart';
import 'package:gcbad_dart/src/models/error_response.dart';
import 'package:http/http.dart';

class GoCardlessHttpUtils {
  static T parse<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return _parse(
      utf8.decode(response.bodyBytes),
      (body) => fromJson(jsonDecode(body) as Map<String, dynamic>),
    );
  }

  static List<T> parseList<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return _parse(
      utf8.decode(response.bodyBytes),
      (body) => (jsonDecode(body) as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static T _parse<T>(String body, T Function(String) fromJson) {
    try {
      return fromJson(body);
    } catch (_) {
      // The body did not parse as the expected model. Re-interpret it as a
      // GoCardless error payload so callers only ever see a
      // GoCardlessException, never a raw JSON/HTTP error.
      throw _errorFrom(body);
    }
  }

  /// Builds a [GoCardlessException] from a response body that failed to parse
  /// as the expected model.
  ///
  /// Handles three shapes: a well-formed GoCardless error object (via
  /// [ErrorResponse.exception]), any other JSON value (via the defensive
  /// [ErrorResponse.createException]), and a body that is not valid JSON at all
  /// (a generic exception) — so the contract of surfacing only
  /// [GoCardlessException] holds even for HTML gateway errors or empty bodies.
  static GoCardlessException _errorFrom(String body) {
    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return GoCardlessException(
        message: 'Unknown error occurred during communication.',
      );
    }

    if (decoded is Map<String, dynamic>) {
      try {
        return ErrorResponse.fromJson(decoded).exception;
      } catch (_) {
        // Not a well-formed ErrorResponse; fall through to the defensive path.
      }
    }

    return ErrorResponse.createException(decoded);
  }
}
