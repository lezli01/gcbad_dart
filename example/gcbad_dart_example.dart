import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/gocardless_country_code.dart';
import 'package:gcbad_dart/src/models/institution_feature.dart';

Future printNumPerCountry(GoCardlessBankAccountDataClient client) async {
  for (var country in GoCardlessCountryCode.values
      .where((element) => element != GoCardlessCountryCode.invalid)) {
    var institutions = await client.getInstitutionMetadatas(country: country);
    print('${country.code}: ${institutions.length}');
  }
}

Future printAccountDetails(GoCardlessBankAccountDataClient client) async {
  var institution = await client.getSandboxInstitution();
  var agreement = await client.createDefaultAgreement(institution);
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

Future collectFeatures(GoCardlessBankAccountDataClient client) async {
  var features = HashSet<InstitutionFeature>();

  for (var country in GoCardlessCountryCode.values) {
    if (country == GoCardlessCountryCode.invalid) {
      continue;
    }

    var instMetas = await client.getInstitutionMetadatas(country: country);

    for (var instMeta in instMetas) {
      sleep(Duration(milliseconds: 100));

      var inst = await client.getInstitutionByMetadata(instMeta);
      features.addAll(inst.supportedFeatures);

      print('After $country -- ${inst.name}');
      print('-------------------------------------------');
      features.forEach(print);
    }
  }
}

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment['GCBAD_ID']!,
      secretKey: Platform.environment['GCBAD_KEY']!);

  var inst = await client.getInstitutionById('KH_OKHBHUHB');

  //await collectFeatures(client);
  // await printNumPerCountry(client);
  // await printAccountDetails(client);
}
