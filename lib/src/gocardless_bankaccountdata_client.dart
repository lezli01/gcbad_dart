import 'dart:convert';

import 'package:gcbad_dart/src/httpclient.dart';
import 'package:gcbad_dart/src/models/end_user_agreement.dart';
import 'package:gcbad_dart/src/models/end_user_agreement_request.dart';
import 'package:gcbad_dart/src/models/institution.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
import 'package:gcbad_dart/src/models/requisition_request.dart';
import 'package:gcbad_dart/src/models/secretandkey.dart';

class GoCardlessBankAccountDataClient {
  final HttpClient webClient;

  GoCardlessBankAccountDataClient(
      {required String secretId, required String secretKey})
      : webClient =
            HttpClient(SecretAndKey(secretId: secretId, secretKey: secretKey));

  Future<List<Institution>> institutions() async {
    return webClient.institutions();
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
