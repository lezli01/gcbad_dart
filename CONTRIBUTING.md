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

Run the same checks as CI and make sure they all pass:

```shell
fvm dart format .                    # formatting
fvm dart analyze --fatal-infos       # static analysis (must be clean)
fvm dart test -x live                # every offline test
fvm dart pub publish --dry-run       # packaging is valid
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

The offline tests need no setup or credentials and cover the models,
serialization, the HTTP client and token flow (via a mock transport), error
handling, and client orchestration. They are what CI runs:

```shell
fvm dart test -x live     # every offline test (excludes the live sandbox suite)
```

The live sandbox suite (`test/gcbad_dart_test.dart`, tagged `live`) runs an
end-to-end flow against the GoCardless **sandbox** and requires:
  - `GCBAD_ID` and `GCBAD_KEY` environment variables (sandbox API credentials), and
  - network access plus a headless browser (it uses `puppeteer` to click
    through the bank-consent web flow).

```shell
GCBAD_ID=... GCBAD_KEY=... fvm dart test -t live
```

Without credentials the live suite is reported as skipped rather than failing,
so a bare `fvm dart test` is safe to run.

## Guidelines

- Keep all HTTP responses flowing through `GoCardlessHttpUtils` so that errors
  consistently surface as `GoCardlessException`.
- Anything intended for consumers must be exported from `lib/gcbad_dart.dart`.

## Commit messages and releases

Commit messages **and** pull request titles follow
[Conventional Commits](https://www.conventionalcommits.org) — `type(scope): description`,
for example `feat: add transaction pagination` or `fix(http): refresh token before expiry`.
Common types are `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, and `ci`. A
CI check validates PR titles and commit subjects, so non-conforming titles are
rejected.

Releases are automated with
[release-please](https://github.com/googleapis/release-please): merging
Conventional Commits to `master` keeps a release pull request up to date that
bumps the version in `pubspec.yaml`, updates `CHANGELOG.md`, and — once merged —
tags the release and publishes to [pub.dev](https://pub.dev). You never bump the
version or edit the changelog by hand.
