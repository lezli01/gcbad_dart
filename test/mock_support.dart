import 'dart:convert';

import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

/// A single request captured by the mock transport built in [buildClient].
class RecordedRequest {
  final String method;
  final Uri url;
  final Map<String, String> headers;
  final String body;

  RecordedRequest(this.method, this.url, this.headers, this.body);

  /// True for the OAuth-style token endpoint that [buildClient] serves
  /// automatically.
  bool get isToken => url.path.endsWith('/token/new/');
}

/// Builds a [Response] whose bytes are the UTF-8 encoding of [body], mirroring
/// how the real API returns JSON.
///
/// Constructing the response from explicit UTF-8 bytes (rather than a plain
/// string) exercises the `utf8.decode(response.bodyBytes)` path that
/// `GoCardlessHttpUtils` relies on for non-ASCII payloads.
Response jsonResponse(String body, {int status = 200}) => Response.bytes(
  utf8.encode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// A valid token payload with a long-lived access window, so that a client
/// built with it fetches a token exactly once and reuses it.
const String tokenJson =
    '{"access":"ACCESS","access_expires":86400,'
    '"refresh":"REFRESH","refresh_expires":2592000}';

/// Base URL every request is expected to hit.
const String baseUrl = 'https://bankaccountdata.gocardless.com/api/v2/';

/// Creates a [GoCardlessBankAccountDataClient] backed by an in-memory
/// [MockClient] so the full stack (client -> http client -> parse utils ->
/// models) can be exercised offline.
///
/// The token endpoint is served automatically from [tokenBody]; every other
/// request is dispatched to [handler]. All requests (token fetches included)
/// are appended to [log] so tests can assert on method, URL, headers, body,
/// and the number of token refreshes.
GoCardlessBankAccountDataClient buildClient(
  Future<Response> Function(RecordedRequest req) handler, {
  required List<RecordedRequest> log,
  String tokenBody = tokenJson,
}) {
  final mock = MockClient((request) async {
    final rec = RecordedRequest(
      request.method,
      request.url,
      request.headers,
      request.body,
    );
    log.add(rec);

    if (rec.isToken && rec.method == 'POST') {
      return jsonResponse(tokenBody);
    }

    return handler(rec);
  });

  return GoCardlessBankAccountDataClient(
    secretId: 'test-secret-id',
    secretKey: 'test-secret-key',
    httpClient: mock,
  );
}

/// How many token refreshes occurred among [log].
int tokenRequestCount(List<RecordedRequest> log) =>
    log.where((r) => r.isToken).length;

// ---------------------------------------------------------------------------
// JSON fixtures modelled on real GoCardless Bank Account Data API responses.
// ---------------------------------------------------------------------------

const String institutionMetadataListJson = '''
[
  {
    "id": "ABNAMRO_ABNANL2A",
    "name": "ABN AMRO Bank",
    "bic": "ABNANL2A",
    "transaction_total_days": "558",
    "countries": ["NL"],
    "logo": "https://cdn.example.com/abn.png"
  },
  {
    "id": "REVOLUT_REVOLT21",
    "name": "Revolut",
    "bic": "REVOLT21",
    "transaction_total_days": "730",
    "countries": ["GB", "IE", "FR"],
    "logo": "https://cdn.example.com/revolut.png"
  }
]
''';

const String institutionJson = '''
{
  "id": "SANDBOXFINANCE_SFIN0000",
  "name": "Sandbox Finance",
  "bic": "SFIN0000",
  "transaction_total_days": "90",
  "countries": ["XX"],
  "logo": "https://cdn.example.com/sandbox.png",
  "supported_features": ["account_selection", "business_accounts"],
  "identification_codes": []
}
''';

const String agreementJson = '''
{
  "id": "agr-123",
  "created": "2024-01-01T00:00:00.000000Z",
  "institution_id": "SANDBOXFINANCE_SFIN0000",
  "max_historical_days": 90,
  "access_valid_for_days": 90,
  "access_scope": ["balances", "details", "transactions"],
  "accepted": null
}
''';

const String accountJson = '''
{
  "id": "acc-1",
  "created": "2024-01-01T00:00:00.000000Z",
  "last_accessed": "2024-01-02T00:00:00.000000Z",
  "iban": "GL0000000000000000",
  "institution_id": "SANDBOXFINANCE_SFIN0000",
  "status": "READY",
  "owner_name": "John Doe"
}
''';

const String balancesJson = '''
{
  "balances": [
    {
      "balanceAmount": {"amount": "1913.12", "currency": "EUR"},
      "balanceType": "interimAvailable",
      "referenceDate": "2024-01-01"
    },
    {
      "balanceAmount": {"amount": "1913.12", "currency": "EUR"},
      "balanceType": "expected",
      "creditLimitIncluded": false
    }
  ]
}
''';

const String accountDetailsJson = '''
{
  "account": {
    "resourceId": "01F3NS4YV94RA29YCH8R0F6BMF",
    "iban": "GL0000000000000000",
    "currency": "EUR",
    "ownerName": "John Doe",
    "name": "Main Account",
    "product": "Checkings",
    "cashAccountType": "CACC",
    "status": "enabled",
    "ownerAddressStructured": {
      "streetName": "Main Street",
      "buildingNumber": "1",
      "townName": "Nuuk",
      "postCode": "3900",
      "country": "GL"
    }
  }
}
''';

const String transactionsJson = '''
{
  "transactions": {
    "booked": [
      {
        "transactionId": "t1",
        "bookingDate": "2024-01-01",
        "valueDate": "2024-01-01",
        "transactionAmount": {"amount": "-15.00", "currency": "EUR"},
        "remittanceInformationUnstructured": "Payment to shop"
      }
    ],
    "pending": []
  }
}
''';

const String errorJson = '''
{
  "summary": "Invalid token",
  "detail": "Token is invalid or expired",
  "status_code": 401
}
''';

/// Builds a requisition payload with the given [status] wire code and account
/// id list.
String requisitionJson({
  String id = 'req-123',
  String status = 'CR',
  List<String> accounts = const [],
}) {
  final accountsField = jsonEncode(accounts);
  return '''
{
  "id": "$id",
  "created": "2024-01-01T00:00:00.000000Z",
  "redirect": "https://www.gocardless.com",
  "status": "$status",
  "institution_id": "SANDBOXFINANCE_SFIN0000",
  "agreement": "agr-123",
  "reference": "ref-1",
  "accounts": $accountsField,
  "user_language": "EN",
  "link": "https://ob.gocardless.com/psd2/start/$id/SANDBOXFINANCE_SFIN0000",
  "ssn": null,
  "account_selection": false,
  "redirect_immediate": false
}
''';
}
