<p align="center">
  <img src="https://raw.githubusercontent.com/lezli01/gcbad_dart/master/.github/assets/gcbad-mark.png" alt="gcbad_dart logo" width="96">
</p>

<h1 align="center">gcbad_dart</h1>

<p align="center">
  <strong>A strongly-typed Dart client for the GoCardless Bank Account Data API.</strong>
</p>

<p align="center">
  Token management, institution discovery, end-user agreements, requisitions (the<br>
  bank-linking consent flow), and account data — balances, details, and transactions —<br>
  behind one ergonomic client, with every API error surfaced as a single exception.
</p>

<p align="center">
  <a href="https://github.com/lezli01/gcbad_dart/actions/workflows/ci.yml"><img src="https://github.com/lezli01/gcbad_dart/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <a href="https://github.com/lezli01/gcbad_dart/releases"><img src="https://img.shields.io/github/v/release/lezli01/gcbad_dart?sort=semver" alt="Latest release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
  <a href="https://www.buymeacoffee.com/lezli01"><img src="https://img.shields.io/badge/Buy_Me_a_Coffee-ffdd00?logo=buymeacoffee&logoColor=black" alt="Buy Me a Coffee"></a>
</p>

<p align="center">
  <a href="#why-gcbad_dart">Why</a> &bull;
  <a href="#features">Features</a> &bull;
  <a href="#getting-started">Getting Started</a> &bull;
  <a href="#usage">Usage</a> &bull;
  <a href="#error-handling">Errors</a> &bull;
  <a href="#contributing">Contributing</a>
</p>

---

## Why gcbad_dart?

The [GoCardless Bank Account Data](https://bankaccountdata.gocardless.com) API (v2)
is a multi-step dance: request an access token, refresh it before it expires,
discover institutions, create an end-user agreement, open a requisition, send the
user through their bank's consent screen, poll until the link is confirmed, then
fan out over the returned account IDs to read balances, details, and transactions.
Doing that by hand means hand-rolling the token lifecycle, remembering the wire
field names, and re-interpreting a different error envelope on every call.

`gcbad_dart` wraps the whole flow behind one strongly-typed client. Tokens refresh
themselves, models are generated from the API's shapes, dates are formatted for you,
and every failure — HTTP, JSON, or an API error payload — arrives as a single
`GoCardlessException`, so your call sites only ever see a valid model or one
exception type.

It is released under the [MIT License](LICENSE) and created by `lezli01` at
[lezli01.is-a.dev](https://lezli01.is-a.dev). Contributions are welcome — see
[Contributing](#contributing).

## Features

Point the client at your credentials and it treats the full bank-linking flow as
first-class, strongly-typed work:

- **Automatic token management.** The bearer token is requested on first use and
  transparently refreshed before it expires — you never touch `/token/new/` or
  `/token/refresh/` yourself.
- **Institution discovery.** List every supported institution, optionally filtered
  by country, or fetch one by id — with `getSandboxInstitution()` for the
  GoCardless sandbox bank.
- **Agreements & requisitions with sensible defaults.** `createDefaultAgreement`
  and `createRequisition` get you into the consent flow in two calls, or drop down
  to the fully-parameterized overloads when you need control.
- **A polling helper for the consent flow.** `waitForRequisitionLink` polls until
  the requisition status becomes `linked`, so you don't script the wait loop.
- **Typed account data.** Read accounts, balances, account details, and
  transactions as Dart models — `getAccounts` fans out over a requisition's
  account ids for you.
- **One error type.** Every HTTP, JSON, or API error surfaces as a single
  `GoCardlessException` built from GoCardless's own error payload — call sites
  handle one type, never a raw HTTP or JSON failure.
- **Generated, strongly-typed models.** Every response is a
  [`json_serializable`](https://pub.dev/packages/json_serializable) model with wire
  field names and enum values mapped for you (e.g. `RequisitionStatus.linked` ↔
  `'LN'`), decoded UTF-8 so non-ASCII fields round-trip correctly.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  gcbad_dart: ^1.0.0
```

You need GoCardless Bank Account Data API credentials — a **secret ID** and
**secret key** — which you can create in the
[GoCardless user portal](https://bankaccountdata.gocardless.com). Treat them as
secrets: load them from the environment or a secret manager rather than
hard-coding them (see [SECURITY.md](SECURITY.md)).

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

See the [`example/`](example/) directory for a complete, runnable program.

## Error Handling

Every API error is thrown as a `GoCardlessException`, whose `message` summarizes
the GoCardless error response (its `summary`, `detail`, and `status_code`). Parse
failures and HTTP errors are re-interpreted the same way, so a single `catch`
covers them all:

```dart
try {
  await client.getInstitutionById('does-not-exist');
} on GoCardlessException catch (e) {
  print(e.message);
}
```

## Architecture

Three layers, from the public API down to the wire:

- **`GoCardlessBankAccountDataClient`** — the public entry point. Ergonomic,
  overloaded methods and orchestration helpers (`waitForRequisitionLink`,
  `getAccounts`); owns model-to-JSON encoding and date formatting.
- **`GoCardlessHttpClient`** — one method per API endpoint. Holds the bearer token
  and refreshes it before every call.
- **`GoCardlessHttpUtils`** — the single parse/error chokepoint. Decodes responses,
  runs the model's `fromJson`, and on any failure re-interprets the body as an
  error and throws `GoCardlessException`.

All models live in `lib/src/models/` and use `json_serializable`; the public
surface is the barrel export in `lib/gcbad_dart.dart`.

## Development

The Flutter/Dart toolchain is pinned with [FVM](https://fvm.app) via `.fvmrc`
(Flutter 3.44.6 / Dart 3.12.2). Provision the SDK and fetch dependencies:

```sh
fvm install
fvm dart pub get
```

Run the same checks as CI before opening a pull request:

```sh
fvm dart format .
fvm dart analyze --fatal-infos
fvm dart test -x live                                    # every offline test
fvm dart pub publish --dry-run
```

After editing any model annotated with `@JsonSerializable`, regenerate the
`*.g.dart` files (never edit them by hand):

```sh
fvm dart run build_runner build --delete-conflicting-outputs
```

The live sandbox suite (`test/gcbad_dart_test.dart`, tagged `live`) runs an
end-to-end flow against the GoCardless **sandbox** and needs `GCBAD_ID` /
`GCBAD_KEY` plus a headless browser; a bare `fvm dart test` is safe because it
skips when credentials are absent.

## Project Status

`gcbad_dart` is at `1.0.0` and covers the full v2 flow: automatic token
management, institution discovery, end-user agreements, requisitions, the
`waitForRequisitionLink` polling helper, and typed retrieval of accounts,
balances, account details, and transactions — all funneled through a single
`GoCardlessException`. The offline test suite exercises the models, serialization,
token flow, error handling, and client orchestration; a scheduled live suite runs
the end-to-end consent flow against the GoCardless sandbox.

## Contributing

Contributions of every size are welcome — bug reports, docs, new endpoints, test
cases, and features. Start here:

- Read the [Contributing guide](CONTRIBUTING.md) for development setup (FVM), the
  checks expected before a pull request, and the commit-message convention.
- Be a good neighbor: this project follows a
  [Code of Conduct](CODE_OF_CONDUCT.md).
- Have a question or an idea? Open a
  [Discussion](https://github.com/lezli01/gcbad_dart/discussions).
- Found a bug or want a feature? Open an
  [issue](https://github.com/lezli01/gcbad_dart/issues/new/choose).

Releases are automated with
[release-please](https://github.com/googleapis/release-please), so pull requests
use [Conventional Commits](https://www.conventionalcommits.org/) titles. Details
are in [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

`gcbad_dart` authenticates with a secret ID and secret key and talks only to the
GoCardless API over HTTPS — but security reports are taken seriously. Please report
suspected vulnerabilities privately via GitHub's private vulnerability reporting
for this repository rather than a public issue. See [SECURITY.md](SECURITY.md) for
details.

## License

`gcbad_dart` is released under the [MIT License](LICENSE). © 2026 lezli01.
