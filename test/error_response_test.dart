import 'dart:convert';

import 'package:gcbad_dart/src/gocardless_exception.dart';
import 'package:gcbad_dart/src/models/error_response.dart';
import 'package:test/test.dart';

ErrorResponse errorFrom(String json) =>
    ErrorResponse.fromJson(jsonDecode(json) as Map<String, dynamic>);

void main() {
  group('ErrorResponse.fromJson / toJson', () {
    test('parses all fields', () {
      final error = errorFrom('''
        {
          "summary": "Invalid token",
          "detail": "Token is invalid or expired",
          "type": "InvalidToken",
          "status_code": 401,
          "_error_code": 1001
        }
      ''');

      expect(error.summary, 'Invalid token');
      expect(error.detail, 'Token is invalid or expired');
      expect(error.type, 'InvalidToken');
      expect(error.statusCode, 401);
      expect(error.errorCode, 1001);
    });

    test('tolerates missing optional fields', () {
      final error = errorFrom('{"status_code": 500}');

      expect(error.summary, isNull);
      expect(error.detail, isNull);
      expect(error.type, isNull);
      expect(error.errorCode, isNull);
      expect(error.statusCode, 500);
    });

    test('round-trips through toJson, omitting null fields', () {
      final json = errorFrom(
        '{"summary": "Nope", "detail": "Bad", "status_code": 400}',
      ).toJson();

      expect(json['summary'], 'Nope');
      expect(json['detail'], 'Bad');
      expect(json['status_code'], 400);
      // include_if_null: false — null members are dropped, not serialised.
      expect(json.containsKey('type'), isFalse);
      expect(json.containsKey('_error_code'), isFalse);
    });
  });

  group('ErrorResponse.exception (strongly-typed payload)', () {
    test('combines summary and detail with status code', () {
      final ex = errorFrom(
        '{"summary": "Invalid token", "detail": "Expired", "status_code": 401}',
      ).exception;

      expect(ex, isA<GoCardlessException>());
      expect(ex.message, 'Invalid token: Expired (401)');
    });

    test('uses summary alone when detail is absent', () {
      final ex = errorFrom(
        '{"summary": "Rate limited", "detail": null, "status_code": 429}',
      ).exception;

      expect(ex.message, 'Rate limited (429)');
    });

    test('uses detail alone when summary is absent', () {
      final ex = errorFrom(
        '{"summary": null, "detail": "Something broke", "status_code": 500}',
      ).exception;

      expect(ex.message, 'Something broke (500)');
    });

    test('falls back to a generic message when both are absent', () {
      final ex = errorFrom('{"status_code": 503}').exception;

      expect(ex.message, 'Error during communication (503)');
    });
  });

  group('ErrorResponse.createException (defensive, untyped payload)', () {
    test('reads list-shaped summary and detail fields', () {
      final ex = ErrorResponse.createException(
        jsonDecode(
          '{"summary": ["Field required"], "detail": ["iban is missing"], '
          '"status_code": 400}',
        ),
      );

      expect(ex.message, 'Field required: iban is missing (400)');
    });

    test('reads a list-shaped summary without detail', () {
      final ex = ErrorResponse.createException(
        jsonDecode('{"summary": ["Field required"], "status_code": 422}'),
      );

      expect(ex.message, 'Field required (422)');
    });

    test('ignores empty or non-string list entries', () {
      final ex = ErrorResponse.createException(
        jsonDecode('{"summary": [], "detail": [42], "status_code": 400}'),
      );

      // Neither list yields a usable string, so only the status code survives.
      expect(ex.message, 'Unknown error occurred during communication. (400)');
    });

    test('handles a payload with no recognisable fields', () {
      final ex = ErrorResponse.createException(jsonDecode('{}'));

      expect(ex.message, 'Unknown error occurred during communication.');
    });

    test('handles a non-map JSON value', () {
      final ex = ErrorResponse.createException(jsonDecode('"just a string"'));

      expect(ex.message, 'Unknown error occurred during communication.');
    });

    test('appends status code even when the message is generic', () {
      final ex = ErrorResponse.createException(
        jsonDecode('{"status_code": 418}'),
      );

      expect(ex.message, 'Unknown error occurred during communication. (418)');
    });
  });
}
