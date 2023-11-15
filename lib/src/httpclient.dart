import 'dart:async';
import 'dart:convert';

import 'package:gcbad_dart/src/httputils.dart';
import 'package:gcbad_dart/src/models/end_user_agreement.dart';
import 'package:gcbad_dart/src/models/institution.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
import 'package:gcbad_dart/src/models/secretandkey.dart';
import 'package:gcbad_dart/src/models/token.dart';

import 'package:http/http.dart' as http;

class HttpClient {
  final SecretAndKey _secretAndKey;

  Token? _token;
  DateTime? _tokenRequestedAt;

  HttpClient(this._secretAndKey);

  Future<List<Institution>> institutions() async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/institutions/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return HttpUtils.parseList(res.body, Institution.fromJson);
  }

  Future<EndUserAgreement> requestAgreement(dynamic body) async {
    await _checkToken();

    final res = await http.post(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        },
        body: body);

    return HttpUtils.parse(res.body, EndUserAgreement.fromJson);
  }

  Future<Requisition> requestRequisition(dynamic body) async {
    await _checkToken();

    final res = await http.post(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/requisitions/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        },
        body: body);

    return HttpUtils.parse(res.body, Requisition.fromJson);
  }

  Future<Requisition> getRequisition(String id) async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/requisitions/$id'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return HttpUtils.parse(res.body, Requisition.fromJson);
  }

  Future _checkToken() async {
    if (_token == null) {
      await _requestNewToken();
    }

    if (DateTime.now().difference(_tokenRequestedAt!).inSeconds + 30 >
        _token!.accessExpiresSeconds) {
      await _requestNewToken();
    }
  }

  Future _requestNewToken() async {
    final res = await http.post(
        Uri.parse('https://bankaccountdata.gocardless.com/api/v2/token/new/'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(_secretAndKey));

    _token = HttpUtils.parse(res.body, Token.fromJson);
    _tokenRequestedAt = DateTime.now();
  }
}
