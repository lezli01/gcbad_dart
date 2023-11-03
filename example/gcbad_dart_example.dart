import 'package:gcbad_dart/gcbad_dart.dart';

void main() async {
  var client = GoCardlessBankAccountDataClient();
  print('Check: ${await client.check()}');
}
