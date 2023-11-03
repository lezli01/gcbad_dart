import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late GoCardlessBankAccountDataClient client;

    setUp(() {
      client = GoCardlessBankAccountDataClient();
    });

    test('First Test', () async {
      var value = await client.check();
      expect(value, contains("google"));
    });
  });
}
