import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/models/requisition.dart';

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment['GCBAD_ID']!,
      secretKey: Platform.environment['GCBAD_KEY']!);

  var institutions = await client.institutions();

  // SANDBOXFINANCE_SFIN0000

  var i = institutions.firstWhere((element) => element.id == 'SANDBOXFINANCE_SFIN0000');

  var agreement = await client.createAgreement('SANDBOXFINANCE_SFIN0000');
  var requisition =
      await client.createRequisition('https://gocardless.com', agreement);

  while (requisition.status != RequisitionStatus.linked) {
    print(JsonEncoder.withIndent('  ').convert(requisition));
    sleep(Duration(seconds: 1));
    requisition = await client.getRequisition(requisition.id);
  }

  print(requisition.link);
}
