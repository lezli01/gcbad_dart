import 'dart:convert';

import 'package:gcbad_dart/src/gocardless_exception.dart';
import 'package:gcbad_dart/src/models/error_response.dart';

class GoCardlessHttpUtils {
  static T parse<T>(String body, T Function(Map<String, dynamic>) fromJson) {
    return _parse(body, (body) => fromJson(jsonDecode(body)));
  }

  static List<T> parseList<T>(
      String body, T Function(Map<String, dynamic>) fromJson) {
    return _parse(body,
        (body) => (jsonDecode(body) as List).map((e) => fromJson(e)).toList());
  }

  static T _parse<T>(String body, T Function(String) fromJson) {
    try {
      return fromJson(body);
    } catch (_) {
      try {
        throw ErrorResponse.fromJson(jsonDecode(body)).exception;
      } on GoCardlessException catch (_) {
        rethrow;
      } catch (_) {
        throw GoCardlessException(
            message: 'Unknown error occurred during communication');
      }
    }
  }
}
