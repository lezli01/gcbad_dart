import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late GoCardlessBankAccountDataClient client;

    setUp(() {
      client = GoCardlessBankAccountDataClient(
        secretId: Platform.environment["GCBAD_ID"]!,
        secretKey: Platform.environment["GCBAD_KEY"]!
      );
    });

    test('First Test', () async {
      print(await client.fetchToken());
    });
  });
}
