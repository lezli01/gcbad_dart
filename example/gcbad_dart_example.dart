import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/gcbad_dart.dart';

/// Prints how many institutions each supported country has.
Future<void> printNumPerCountry(GoCardlessBankAccountDataClient client) async {
  for (var country in GoCardlessCountryCode.values.where(
    (country) => country != GoCardlessCountryCode.invalid,
  )) {
    var institutions = await client.getInstitutionMetadatas(country: country);
    print('${country.code}: ${institutions.length}');
  }
}

/// Collects the distinct set of features supported across all institutions.
Future<void> collectFeatures(GoCardlessBankAccountDataClient client) async {
  var features = HashSet<InstitutionFeature>();

  for (var country in GoCardlessCountryCode.values.where(
    (country) => country != GoCardlessCountryCode.invalid,
  )) {
    var instMetas = await client.getInstitutionMetadatas(country: country);

    for (var instMeta in instMetas) {
      sleep(Duration(milliseconds: 100));

      var inst = await client.getInstitutionByMetadata(instMeta);
      features.addAll(inst.supportedFeatures);
    }
  }

  features.forEach(print);
}

void main() async {
  var client = GoCardlessBankAccountDataClient(
    secretId: Platform.environment['GCBAD_ID']!,
    secretKey: Platform.environment['GCBAD_KEY']!,
  );

  // Start the bank-linking flow against the GoCardless sandbox institution.
  var institution = await client.getSandboxInstitution();
  var agreement = await client.createDefaultAgreement(institution);
  var requisition = await client.createRequisition(agreement);

  // Open this link in a browser to authenticate with the (sandbox) bank, then
  // wait for the requisition to reach the linked state.
  print('Authenticate here: ${requisition.link}');
  requisition = await client.waitForRequisitionLink(requisition);

  // Read data for each linked account.
  var accounts = await client.getAccounts(requisition);
  var encoder = JsonEncoder.withIndent('  ');

  for (var account in accounts) {
    print('\nAccount: ${account.ownerName}');

    var balances = await client.getBalances(account);
    print('Balances:\n${encoder.convert(balances)}');

    var transactions = await client.getTransactions(
      account,
      dateFrom: DateTime.now().add(Duration(days: -30)),
      dateTo: DateTime.now(),
    );

    var creditors = <String>{
      for (var t in transactions.transactions.booked) t.creditorName ?? '',
      for (var t in transactions.transactions.pending) t.creditorName ?? '',
    }..remove('');
    print('Creditors seen in the last 30 days: ${creditors.join(', ')}');
  }
}
