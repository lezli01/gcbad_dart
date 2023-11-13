import 'package:gcbad_dart/src/httpclient.dart';
import 'package:gcbad_dart/src/models/integration.dart';
import 'package:gcbad_dart/src/models/secretandkey.dart';

class GoCardlessBankAccountDataClient {
  final HttpClient webClient;

  GoCardlessBankAccountDataClient(
      {required String secretId, required String secretKey})
      : webClient =
            HttpClient(SecretAndKey(secretId: secretId, secretKey: secretKey));

  Future<List<Integration>> institutions() async {
    return webClient.institutions();
  }
}
