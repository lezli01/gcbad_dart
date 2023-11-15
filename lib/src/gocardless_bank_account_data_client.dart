import 'dart:convert';

import 'package:gcbad_dart/src/gocardless_country_code.dart';
import 'package:gcbad_dart/src/gocardless_http_client.dart';
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

  Future<EndUserAgreement> createAgreement(String institutionId) async {
    var request =
        EndUserAgreementRequest.withDefaults(institutionId: institutionId);

    return webClient.requestAgreement(jsonEncode(request));
  }

  Future<Requisition> createRequisition(
      String redirectUrl, EndUserAgreement agreement) async {
    var request = RequisitionRequest.withDefaults(
        redirectUrl: redirectUrl,
        institutionId: agreement.institutionId,
        agreementId: agreement.id);

    return webClient.requestRequisition(jsonEncode(request));
  }

  Future<Requisition> getRequisition(String id) async {
    return webClient.getRequisition(id);
  }
}
