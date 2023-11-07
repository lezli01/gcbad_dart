import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment["GCBAD_ID"]!,
      secretKey: Platform.environment["GCBAD_KEY"]!);

  var token = await client.fetchToken();
  print(JsonEncoder.withIndent('  ').convert(token));
}
