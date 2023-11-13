import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/models/end_user_agreement_request.dart';

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: "asd",// Platform.environment["GCBAD_ID"]!,
      secretKey: Platform.environment["GCBAD_KEY"]!);

  var a = await client.institutions();

  // SANDBOXFINANCE_SFIN0000

  print(jsonEncode(EndUserAgreementRequest.withDefaults(
      insitutionId: 'SANDBOXFINANCE_SFIN0000')));
}
