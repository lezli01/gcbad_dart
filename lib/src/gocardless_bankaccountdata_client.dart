import 'package:http/http.dart' as http;

class GoCardlessBankAccountDataClient {
  Future<String> check() async {
    var res = await http.get(Uri.parse("https://www.google.com"));
    return res.body;
  }
}
