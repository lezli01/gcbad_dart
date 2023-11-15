import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/gocardless_country_code.dart';

void printNumPerCountry(GoCardlessBankAccountDataClient client) async {
  for (var country in GoCardlessCountryCode.values) {
    var institutions = await client.getInstitutionMetadatas(country: country);
    print('${country.code}: ${institutions.length}');
  }
}

void main() async {
  var client = GoCardlessBankAccountDataClient(
      secretId: Platform.environment['GCBAD_ID']!,
      secretKey: Platform.environment['GCBAD_KEY']!);

  printNumPerCountry(client);
}
