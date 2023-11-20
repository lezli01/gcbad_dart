import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/gocardless_country_code.dart';

void printNumPerCountry(GoCardlessBankAccountDataClient client) async {
  for (var country in GoCardlessCountryCode.values) {
    var institutions = await client.getInstitutionMetadatas(country: country);
    print('${country.code}: ${institutions.length}');
  }
}

void printAccountDetails(GoCardlessBankAccountDataClient client) async {
  var institution = await client.getSandboxInstitution();
  var agreement = await client.createAgreement(institution);
  var requisition = await client.createRequisition(agreement);

  print(requisition.link);
  requisition = await client.waitForRequisitionLink(requisition);
  var accounts = await client.getAccounts(requisition);

  for (var account in accounts) {
    print(account.ownerName);
    print(JsonEncoder.withIndent('  ')
        .convert(await client.getBalances(account)));
  }
}

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment['GCBAD_ID']!,
      secretKey: Platform.environment['GCBAD_KEY']!);

  //printNumPerCountry(client);
  printAccountDetails(client);
}
