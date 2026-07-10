# gcbad_dart

A Dart client library for the [GoCardless Bank Account Data](https://bankaccountdata.gocardless.com) API (v2).

It wraps the full flow of the API — token management, institution discovery, end-user agreements, requisitions (the bank-linking consent flow), and retrieval of account balances, details, and transactions — behind an ergonomic, strongly-typed interface.

## Features

- Automatic access-token management (requests and refreshes tokens transparently).
- Institution discovery, optionally filtered by country.
- End-user agreement and requisition creation, with sensible defaults.
- Polling helper (`waitForRequisitionLink`) for the consent flow.
- Typed access to accounts, balances, account details, and transactions.
- All API errors surface as a single `GoCardlessException`.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  gcbad_dart: ^1.0.0
```

You need GoCardless Bank Account Data API credentials (a secret ID and secret
key), which you can create in the
[GoCardless user portal](https://bankaccountdata.gocardless.com).

## Usage

```dart
import 'package:gcbad_dart/gcbad_dart.dart';

Future<void> main() async {
  final client = GoCardlessBankAccountDataClient(
    secretId: 'your-secret-id',
    secretKey: 'your-secret-key',
  );

  // Discover institutions (optionally by country).
  final institutions = await client.getInstitutionMetadatas(
      country: GoCardlessCountryCode.unitedKingdom);

  // Create an agreement + requisition to start the bank-linking flow.
  final institution = institutions.first;
  final agreement = await client.createDefaultAgreement(institution);
  final requisition = await client.createRequisition(agreement);

  // Send the user to `requisition.link` to authenticate with their bank,
  // then wait for the requisition to become linked.
  print('Open this link to authenticate: ${requisition.link}');
  final linked = await client.waitForRequisitionLink(requisition);

  // Read account data.
  final accounts = await client.getAccounts(linked);
  for (final account in accounts) {
    final balances = await client.getBalances(account);
    final transactions = await client.getTransactions(account);
    print('${account.ownerName}: '
        '${balances.balances.length} balances, '
        '${transactions.transactions.booked.length} booked transactions');
  }
}
```

The GoCardless sandbox institution (`SANDBOXFINANCE_SFIN0000`) is handy for
testing; `client.getSandboxInstitution()` returns it directly.

See the [`example/`](example/) directory for more.

## Error handling

Every API error is thrown as a `GoCardlessException`, whose `message`
summarizes the GoCardless error response:

```dart
try {
  await client.getInstitutionById('does-not-exist');
} on GoCardlessException catch (e) {
  print(e.message);
}
```

## Contributing

Contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Released under the [MIT License](LICENSE).
