import 'dart:convert';

import 'package:gcbad_dart/src/models/secretandkey.dart';
import 'package:gcbad_dart/src/models/token.dart';
import 'package:http/http.dart' as http;

class GoCardlessBankAccountDataClient {
  final String secretId;
  final String secretKey;

  GoCardlessBankAccountDataClient(
      {required this.secretId, required this.secretKey});

  Future<Token> fetchToken() async {
    final res = await http.post(
        Uri.parse("https://bankaccountdata.gocardless.com/api/v2/token/new/"),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body:
            jsonEncode(SecretAndKey(secretId: secretId, secretKey: secretKey)));

    return Token.fromJson(jsonDecode(res.body));
  }
}
