import 'dart:convert';

import 'package:gcbad_dart/src/models/error_response.dart';
import 'package:test/test.dart';

void main() {
  group('Test for ErrorResponse', () {
    setUp(() {});

    test('Test parsing', () {
      ErrorResponse.fromJson(
        jsonDecode(
          '{'
          '"summary": "",'
          '"detail": "",'
          '"status_code": 200'
          '}',
        ),
      );
    });
  });
}
