import 'dart:convert';

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
