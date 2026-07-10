# Contributing to gcbad_dart

Thanks for your interest in contributing! This document covers the essentials
for working on the package.

## Development setup

The toolchain is pinned with [FVM](https://fvm.app) via `.fvmrc` (Flutter 3.44.6 /
Dart 3.12.2). Install [FVM](https://fvm.app/docs/getting_started/installation),
provision the pinned SDK, then fetch dependencies:

```shell
fvm install         # provision the pinned Flutter/Dart SDK
fvm dart pub get
```

Prefix Dart commands with `fvm` so they run against the pinned SDK.

## Before opening a pull request

Please make sure the following all pass:

```shell
fvm dart format .        # formatting
fvm dart analyze         # static analysis (must be clean)
fvm dart test            # tests
```

## Code generation

Models use [`json_serializable`](https://pub.dev/packages/json_serializable).
If you add or change a model annotated with `@JsonSerializable`, regenerate the
`*.g.dart` files:

```shell
fvm dart run build_runner build --delete-conflicting-outputs
```

Never edit `*.g.dart` files by hand — they are generated and your changes will
be overwritten.

## Tests

- `test/error_response_test.dart` and `test/httputils_test.dart` are offline
  unit tests and run without any setup.
- `test/gcbad_dart_test.dart` runs an end-to-end flow against the GoCardless
  **sandbox** and requires:
  - `GCBAD_ID` and `GCBAD_KEY` environment variables (sandbox API credentials), and
  - network access plus a headless browser (it uses `puppeteer` to click
    through the bank-consent web flow).

  ```shell
  GCBAD_ID=... GCBAD_KEY=... fvm dart test test/gcbad_dart_test.dart
  ```

## Guidelines

- Keep all HTTP responses flowing through `GoCardlessHttpUtils` so that errors
  consistently surface as `GoCardlessException`.
- Anything intended for consumers must be exported from `lib/gcbad_dart.dart`.
