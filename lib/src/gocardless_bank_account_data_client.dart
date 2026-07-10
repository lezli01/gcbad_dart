import 'dart:convert';

import 'package:gcbad_dart/src/gocardless_country_code.dart';
import 'package:gcbad_dart/src/gocardless_http_client.dart';
import 'package:gcbad_dart/src/models/account.dart';
import 'package:gcbad_dart/src/models/account_details.dart';
import 'package:gcbad_dart/src/models/balances.dart';
import 'package:gcbad_dart/src/models/end_user_agreement.dart';
import 'package:gcbad_dart/src/models/end_user_agreement_request.dart';
import 'package:gcbad_dart/src/models/information_to_access.dart';
import 'package:gcbad_dart/src/models/institution.dart';
import 'package:gcbad_dart/src/models/institution_metadata.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
import 'package:gcbad_dart/src/models/requisition_request.dart';
import 'package:gcbad_dart/src/models/secretandkey.dart';
import 'package:gcbad_dart/src/models/transactions.dart';
import 'package:http/http.dart' as http;

class GoCardlessBankAccountDataClient {
  static const String sandboxInstitutionId = 'SANDBOXFINANCE_SFIN0000';
  final GoCardlessHttpClient webClient;

  GoCardlessBankAccountDataClient({
    required String secretId,
    required String secretKey,
    http.Client? httpClient,
  }) : webClient = GoCardlessHttpClient(
         SecretAndKey(secretId: secretId, secretKey: secretKey),
         httpClient: httpClient,
       );

  Future<List<InstitutionMetadata>> getInstitutionMetadatas({
    GoCardlessCountryCode? country,
  }) async {
    return webClient.getInstitutionMetadatas(country);
  }

  Future<Institution> getInstitutionByMetadata(
    InstitutionMetadata institutionMetadata,
  ) {
    return webClient.getInstitution(institutionMetadata.id);
  }

  Future<Institution> getInstitutionById(String institutionId) {
    return webClient.getInstitution(institutionId);
  }

  Future<Institution> getSandboxInstitution() {
    return getInstitutionById(sandboxInstitutionId);
  }

  Future<EndUserAgreement> createAgreementById(
    String institutionId,
    int maxHistoricalDays,
    int accessValidForDays,
    List<InformationToAccess> accessScope,
  ) async {
    var request = EndUserAgreementRequest(
      institutionId: institutionId,
      maxHistoricalDays: maxHistoricalDays,
      accessValidForDays: accessValidForDays,
      accessScope: accessScope,
    );

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<EndUserAgreement> createAgreement(
    InstitutionMetadata institutionMetadata,
    int maxHistoricalDays,
    int accessValidForDays,
    List<InformationToAccess> accessScope,
  ) async {
    var request = EndUserAgreementRequest(
      institutionId: institutionMetadata.id,
      maxHistoricalDays: maxHistoricalDays,
      accessValidForDays: accessValidForDays,
      accessScope: accessScope,
    );

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<EndUserAgreement> createDefaultAgreementById(
    String institutionId,
  ) async {
    var request = EndUserAgreementRequest.withDefaults(
      institutionId: institutionId,
    );

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<EndUserAgreement> createDefaultAgreement(
    InstitutionMetadata institutionMetadata,
  ) async {
    var request = EndUserAgreementRequest.withDefaults(
      institutionId: institutionMetadata.id,
    );

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<Requisition> createRequisition(
    EndUserAgreement agreement, {
    String? redirectUrl,
  }) async {
    var request = RequisitionRequest.withDefaults(
      redirectUrl: redirectUrl ?? "https://www.gocardless.com",
      institutionId: agreement.institutionId,
      agreementId: agreement.id,
    );

    return webClient.requestRequisition(jsonEncode(request));
  }

  Future<Requisition> getRequisition(String id) async {
    return webClient.getRequisition(id);
  }

  Future<Requisition> waitForRequisitionLinkById(String requisitionId) async {
    var requisition = await getRequisition(requisitionId);

    while (requisition.status != RequisitionStatus.linked) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      requisition = await getRequisition(requisitionId);
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

  Future<List<Account>> getAccountsById(String requisitionId) async {
    return await getAccounts(await getRequisition(requisitionId));
  }

  Future<Balances> getBalances(Account account) async {
    return getBalancesById(account.id);
  }

  Future<Balances> getBalancesById(String accountId) async {
    return webClient.getBalances(accountId);
  }

  Future<AccountDetails> getAccountDetails(Account account) {
    return getAccountDetailsById(account.id);
  }

  Future<AccountDetails> getAccountDetailsById(String accountId) {
    return webClient.getAccountDetails(accountId);
  }

  Future<Transactions> getTransactions(
    Account account, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return getTransactionsById(account.id, dateFrom: dateFrom, dateTo: dateTo);
  }

  Future<Transactions> getTransactionsById(
    String accountId, {
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return webClient.getTransactions(
      accountId,
      dateToStringFormat(dateFrom),
      dateToStringFormat(dateTo),
    );
  }

  String? dateToStringFormat(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }

    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  /// Closes the underlying HTTP client and releases its connection pool. Call
  /// this when the client is no longer needed.
  void close() => webClient.close();
}
