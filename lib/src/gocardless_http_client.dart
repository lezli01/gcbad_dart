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
  static const String _baseUrl =
      'https://bankaccountdata.gocardless.com/api/v2/';

  final SecretAndKey _secretAndKey;

  /// The [http.Client] used for every request. Reusing a single client lets
  /// the underlying connection be pooled and kept alive across calls, which is
  /// the usage recommended by `package:http`. Call [close] when done.
  final http.Client _httpClient;

  Token? _token;
  DateTime? _tokenRequestedAt;

  GoCardlessHttpClient(this._secretAndKey, {http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<List<InstitutionMetadata>> getInstitutionMetadatas(
    GoCardlessCountryCode? country,
  ) async {
    await _checkToken();

    var uri = Uri.parse('${_baseUrl}institutions/');

    if (country != null) {
      uri = uri.replace(queryParameters: {'country': country.code});
    }

    final res = await _httpClient.get(uri, headers: _headers());

    return GoCardlessHttpUtils.parseList(res, InstitutionMetadata.fromJson);
  }

  Future<Institution> getInstitution(String id) async {
    await _checkToken();

    final res = await _httpClient.get(
      Uri.parse('${_baseUrl}institutions/$id/'),
      headers: _headers(),
    );

    return GoCardlessHttpUtils.parse(res, Institution.fromJson);
  }

  Future<EndUserAgreement> requestAgreement(String body) async {
    await _checkToken();

    final res = await _httpClient.post(
      Uri.parse('${_baseUrl}agreements/enduser/'),
      headers: _headers(json: true),
      body: body,
    );

    return GoCardlessHttpUtils.parse(res, EndUserAgreement.fromJson);
  }

  Future<Requisition> requestRequisition(String body) async {
    await _checkToken();

    final res = await _httpClient.post(
      Uri.parse('${_baseUrl}requisitions/'),
      headers: _headers(json: true),
      body: body,
    );

    return GoCardlessHttpUtils.parse(res, Requisition.fromJson);
  }

  Future<Requisition> getRequisition(String requisitionId) async {
    await _checkToken();

    final res = await _httpClient.get(
      Uri.parse('${_baseUrl}requisitions/$requisitionId/'),
      headers: _headers(),
    );

    return GoCardlessHttpUtils.parse(res, Requisition.fromJson);
  }

  Future<Account> getAccount(String accountId) async {
    await _checkToken();

    final res = await _httpClient.get(
      Uri.parse('${_baseUrl}accounts/$accountId/'),
      headers: _headers(),
    );

    return GoCardlessHttpUtils.parse(res, Account.fromJson);
  }

  Future<Balances> getBalances(String accountId) async {
    await _checkToken();

    final res = await _httpClient.get(
      Uri.parse('${_baseUrl}accounts/$accountId/balances/'),
      headers: _headers(),
    );

    return GoCardlessHttpUtils.parse(res, Balances.fromJson);
  }

  Future<AccountDetails> getAccountDetails(String accountId) async {
    await _checkToken();

    final res = await _httpClient.get(
      Uri.parse('${_baseUrl}accounts/$accountId/details/'),
      headers: _headers(),
    );

    return GoCardlessHttpUtils.parse(res, AccountDetails.fromJson);
  }

  Future<Transactions> getTransactions(
    String accountId,
    String? dateFrom,
    String? dateTo,
  ) async {
    await _checkToken();

    var uri = Uri.parse('${_baseUrl}accounts/$accountId/transactions/');

    if (dateFrom != null && dateTo != null) {
      uri = uri.replace(
        queryParameters: {'date_from': dateFrom, 'date_to': dateTo},
      );
    }

    final res = await _httpClient.get(uri, headers: _headers());

    return GoCardlessHttpUtils.parse(res, Transactions.fromJson);
  }

  /// Common request headers. Pass [json] for requests that carry a JSON body.
  Map<String, String> _headers({bool json = false}) => {
    'accept': 'application/json',
    if (json) 'Content-Type': 'application/json',
    'Authorization': 'Bearer ${_token!.accessToken}',
  };

  Future<void> _checkToken() async {
    if (_token == null) {
      await _requestNewToken();
      return;
    }

    if (DateTime.now().difference(_tokenRequestedAt!).inSeconds + 30 >
        _token!.accessExpiresSeconds) {
      await _requestNewToken();
    }
  }

  Future<void> _requestNewToken() async {
    final res = await _httpClient.post(
      Uri.parse('${_baseUrl}token/new/'),
      headers: const {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(_secretAndKey),
    );

    _token = GoCardlessHttpUtils.parse(res, Token.fromJson);
    _tokenRequestedAt = DateTime.now();
  }

  /// Closes the underlying [http.Client] and releases its connection pool.
  void close() => _httpClient.close();
}
