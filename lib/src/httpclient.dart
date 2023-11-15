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

  static final Finalizer<Timer?> _finalizer =
      Finalizer((timer) => timer?.cancel());

  Timer? _tokenRefreshTimer;

  HttpClient(this._secretAndKey);

  Future<List<Institution>> institutions() async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            "https://bankaccountdata.gocardless.com/api/v2/institutions/"),
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
            "https://bankaccountdata.gocardless.com/api/v2/agreements/enduser/"),
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
            "https://bankaccountdata.gocardless.com/api/v2/requisitions/"),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        },
        body: body);

    return HttpUtils.parse(res.body, Requisition.fromJson);
  }

  Future _checkToken() async {
    if (_token == null) {
      await _initializeToken();
    }
  }

  Future _initializeToken() async {
    final res = await http.post(
        Uri.parse("https://bankaccountdata.gocardless.com/api/v2/token/new/"),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(_secretAndKey));

    _token = HttpUtils.parse(res.body, Token.fromJson);

    if (_tokenRefreshTimer != null) {
      _tokenRefreshTimer!.cancel();
      _finalizer.detach(this);
    }

    _tokenRefreshTimer = Timer(
        Duration(seconds: _token!.accessExpiresSeconds), _initializeToken);
    _finalizer.attach(this, _tokenRefreshTimer, detach: this);
  }
}
