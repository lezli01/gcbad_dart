import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/models/end_user_agreement_request.dart';

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment['GCBAD_ID']!,
      secretKey: Platform.environment['GCBAD_KEY']!);

  var institutions = await client.institutions();

  // SANDBOXFINANCE_SFIN0000

  var agreement = await client.createAgreement('SANDBOXFINANCE_SFIN0000');
  var requisition = await client.createRequisition(agreement);

  print('asd');
}
