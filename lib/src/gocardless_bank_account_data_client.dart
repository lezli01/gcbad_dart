import 'dart:convert';
import 'dart:io';

import 'package:gcbad_dart/src/gocardless_country_code.dart';
import 'package:gcbad_dart/src/gocardless_http_client.dart';
import 'package:gcbad_dart/src/models/account.dart';
import 'package:gcbad_dart/src/models/balances.dart';
import 'package:gcbad_dart/src/models/end_user_agreement.dart';
import 'package:gcbad_dart/src/models/end_user_agreement_request.dart';
import 'package:gcbad_dart/src/models/institution.dart';
import 'package:gcbad_dart/src/models/institution_metadata.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
import 'package:gcbad_dart/src/models/requisition_request.dart';
import 'package:gcbad_dart/src/models/secretandkey.dart';

class GoCardlessBankAccountDataClient {
  static const String sandboxInstitutionId = 'SANDBOXFINANCE_SFIN0000';
  final GoCardlessHttpClient webClient;

  GoCardlessBankAccountDataClient(
      {required String secretId, required String secretKey})
      : webClient = GoCardlessHttpClient(
            SecretAndKey(secretId: secretId, secretKey: secretKey));

  Future<List<InstitutionMetadata>> getInstitutionMetadatas(
      {GoCardlessCountryCode? country}) async {
    return webClient.getInstitutionMetadatas(country);
  }

  Future<Institution> getInstitutionByMetadata(
      InstitutionMetadata institutionMetadata) {
    return webClient.getInstitution(institutionMetadata.id);
  }

  Future<Institution> getInstitutionById(String id) {
    return webClient.getInstitution(id);
  }

  Future<Institution> getSandboxInstitution() {
    return getInstitutionById(sandboxInstitutionId);
  }

  Future<EndUserAgreement> createAgreementById(String institutionId) async {
    var request =
        EndUserAgreementRequest.withDefaults(institutionId: institutionId);

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<EndUserAgreement> createAgreement(
      InstitutionMetadata institutionMetadata) async {
    var request = EndUserAgreementRequest.withDefaults(
        institutionId: institutionMetadata.id);

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<Requisition> createRequisition(EndUserAgreement agreement,
      {String? redirectUrl}) async {
    var request = RequisitionRequest.withDefaults(
        redirectUrl: redirectUrl ?? "https://www.gocardless.com",
        institutionId: agreement.institutionId,
        agreementId: agreement.id);

    return webClient.requestRequisition(jsonEncode(request));
  }

  Future<Requisition> getRequisition(String id) async {
    return webClient.getRequisition(id);
  }

  Future<Requisition> waitForRequisitionLinkById(String id) async {
    var requisition = await getRequisition(id);

    while (requisition.status != RequisitionStatus.linked) {
      sleep(Duration(milliseconds: 100));
      requisition = await getRequisition(id);
    }

    return requisition;
  }

  Future<Requisition> waitForRequisitionLink(Requisition requisition) async {
    return waitForRequisitionLinkById(requisition.id);
  }

  Future<Account> getAccountById(String id) async {
    return webClient.getAccount(id);
  }

  Future<List<Account>> getAccounts(Requisition requisition) async {
    var accounts = <Account>[];

    if (requisition.accounts == null) {
      return accounts;
    }

    for (var accountId in requisition.accounts!) {
      accounts.add(await getAccountById(accountId));
    }

    return accounts;
  }

  Future<Balances> getBalances(Account account) async {
    return getBalancesById(account.id);
  }

  Future<Balances> getBalancesById(String id) async {
    return webClient.getBalances(id);
  }
}
