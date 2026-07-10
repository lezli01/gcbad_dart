import 'package:gcbad_dart/gcbad_dart.dart';
import 'package:gcbad_dart/src/gocardless_http_utils.dart';
import 'package:test/test.dart';

import 'mock_support.dart';

void main() {
  group('GoCardlessHttpUtils.parse', () {
    test('decodes a valid payload into a model', () {
      final token = GoCardlessHttpUtils.parse(
        jsonResponse(tokenJson),
        Token.fromJson,
      );

      expect(token.accessToken, 'ACCESS');
      expect(token.accessExpiresSeconds, 86400);
      expect(token.refreshToken, 'REFRESH');
    });

    test('UTF-8 decodes non-ASCII bytes (not Latin-1)', () {
      // The parser reads response.bodyBytes and utf8.decodes them; a naive
      // .body / Latin-1 read would mangle these characters.
      final res = jsonResponse(
        '{"id":"acc-1","created":null,"last_accessed":null,"iban":null,'
        '"institution_id":"INST","status":null,'
        '"owner_name":"Jörg Müller — Ölçük"}',
      );

      final account = GoCardlessHttpUtils.parse(res, Account.fromJson);

      expect(account.ownerName, 'Jörg Müller — Ölçük');
    });

    test('turns a GoCardless error payload into a GoCardlessException', () {
      expect(
        () => GoCardlessHttpUtils.parse(
          jsonResponse(errorJson, status: 401),
          Token.fromJson,
        ),
        throwsA(
          isA<GoCardlessException>().having(
            (e) => e.message,
            'message',
            'Invalid token: Token is invalid or expired (401)',
          ),
        ),
      );
    });

    test('routes list-shaped validation errors through createException', () {
      // ErrorResponse.fromJson cannot cast the list-shaped summary/detail, so
      // parse must fall back to the defensive createException path.
      final res = jsonResponse(
        '{"summary":["Field required"],"detail":["iban is missing"],'
        '"status_code":400}',
        status: 400,
      );

      expect(
        () => GoCardlessHttpUtils.parse(res, Token.fromJson),
        throwsA(
          isA<GoCardlessException>().having(
            (e) => e.message,
            'message',
            'Field required: iban is missing (400)',
          ),
        ),
      );
    });

    test('never leaks a raw JSON/HTTP error for a non-JSON body', () {
      // Gateways (502/503) frequently return HTML. The documented contract is
      // that callers only ever see a model or a GoCardlessException — never a
      // raw FormatException.
      final res = jsonResponse(
        '<html><body>502 Bad Gateway</body></html>',
        status: 502,
      );

      expect(
        () => GoCardlessHttpUtils.parse(res, Token.fromJson),
        throwsA(isA<GoCardlessException>()),
      );
    });

    test('empty body surfaces as a GoCardlessException', () {
      expect(
        () => GoCardlessHttpUtils.parse(jsonResponse(''), Token.fromJson),
        throwsA(isA<GoCardlessException>()),
      );
    });
  });

  group('GoCardlessHttpUtils.parseList', () {
    test('decodes a JSON array into a list of models', () {
      final metadatas = GoCardlessHttpUtils.parseList(
        jsonResponse(institutionMetadataListJson),
        InstitutionMetadata.fromJson,
      );

      expect(metadatas, hasLength(2));
      expect(metadatas.map((m) => m.id), [
        'ABNAMRO_ABNANL2A',
        'REVOLUT_REVOLT21',
      ]);
    });

    test('decodes an empty array into an empty list', () {
      final metadatas = GoCardlessHttpUtils.parseList(
        jsonResponse('[]'),
        InstitutionMetadata.fromJson,
      );

      expect(metadatas, isEmpty);
    });

    test('turns an error object (not an array) into a GoCardlessException', () {
      expect(
        () => GoCardlessHttpUtils.parseList(
          jsonResponse(errorJson, status: 401),
          InstitutionMetadata.fromJson,
        ),
        throwsA(
          isA<GoCardlessException>().having(
            (e) => e.message,
            'message',
            'Invalid token: Token is invalid or expired (401)',
          ),
        ),
      );
    });

    test('never leaks a raw JSON/HTTP error for a non-JSON body', () {
      expect(
        () => GoCardlessHttpUtils.parseList(
          jsonResponse('Service Unavailable', status: 503),
          InstitutionMetadata.fromJson,
        ),
        throwsA(isA<GoCardlessException>()),
      );
    });
  });
}
