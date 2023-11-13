import 'dart:convert';

import 'package:gcbad_dart/src/models/error_response.dart';
import 'package:test/test.dart';

void main() {
  group('Test for ErrorResponse', () {
    setUp(() {});

    test('Test parsing', () {
      try {
        jsonDecode('{}') as List;
      } catch (_) {}
    });
  });
}
