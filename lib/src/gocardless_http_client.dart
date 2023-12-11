import 'dart:async';
import 'dart:convert';

import 'package:gcbad_dart/src/gocardless_country_code.dart';
import 'package:gcbad_dart/src/gocardless_http_utils.dart';
import 'package:gcbad_dart/src/models/account.dart';
import 'package:gcbad_dart/src/models/account_details.dart';
import 'package:gcbad_dart/src/models/balances.dart';
import 'package:gcbad_dart/src/models/end_user_agreement.dart';
import 'package:gcbad_dart/src/models/institution.dart';
import 'package:gcbad_dart/src/models/institution_metadata.dart';
import 'package:gcbad_dart/src/models/requisition.dart';
import 'package:gcbad_dart/src/models/secretandkey.dart';
import 'package:gcbad_dart/src/models/token.dart';
import 'package:gcbad_dart/src/models/transactions.dart';

import 'package:http/http.dart' as http;

class GoCardlessHttpClient {
  final SecretAndKey _secretAndKey;

  Token? _token;
  DateTime? _tokenRequestedAt;

  GoCardlessHttpClient(this._secretAndKey);

  Future<List<InstitutionMetadata>> getInstitutionMetadatas(
      GoCardlessCountryCode? country) async {
    await _checkToken();

    var uri = Uri.parse(
        'https://bankaccountdata.gocardless.com/api/v2/institutions/');

    if (country != null) {
      uri = uri.replace(queryParameters: {'country': country.code});
    }

    final res = await http.get(uri, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_token!.accessToken}'
    });

    return GoCardlessHttpUtils.parseList(
        res.body, InstitutionMetadata.fromJson);
  }

  Future<Institution> getInstitution(String id) async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/institutions/$id/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return GoCardlessHttpUtils.parse(res.body, Institution.fromJson);
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

    return GoCardlessHttpUtils.parse(res.body, EndUserAgreement.fromJson);
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

    return GoCardlessHttpUtils.parse(res.body, Requisition.fromJson);
  }

  Future<Requisition> getRequisition(String requisitionId) async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/requisitions/$requisitionId/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return GoCardlessHttpUtils.parse(res.body, Requisition.fromJson);
  }

  Future<Account> getAccount(String accountId) async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountId/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return GoCardlessHttpUtils.parse(res.body, Account.fromJson);
  }

  Future<Balances> getBalances(String accountId) async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountId/balances/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return GoCardlessHttpUtils.parse(res.body, Balances.fromJson);
  }

  Future<AccountDetails> getAccountDetails(String accountId) async {
    await _checkToken();

    final res = await http.get(
        Uri.parse(
            'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountId/details/'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_token!.accessToken}'
        });

    return GoCardlessHttpUtils.parse(res.body, AccountDetails.fromJson);
  }

  Future<Transactions> getTransactions(
      String accountId, String? dateFrom, String? dateTo) async {
    await _checkToken();

    var uri = Uri.parse(
        'https://bankaccountdata.gocardless.com/api/v2/accounts/$accountId/transactions/');

    if (dateFrom != null && dateTo != null) {
      uri = uri
          .replace(queryParameters: {'date_from': dateFrom, 'date_to': dateTo});
    }

    final res = await http.get(uri, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_token!.accessToken}'
    });

    return GoCardlessHttpUtils.parse(res.body, Transactions.fromJson);
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

    _token = GoCardlessHttpUtils.parse(res.body, Token.fromJson);
    _tokenRequestedAt = DateTime.now();
  }
}
