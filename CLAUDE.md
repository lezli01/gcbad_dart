# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`gcbad_dart` is a Dart client library for the [GoCardless Bank Account Data](https://bankaccountdata.gocardless.com) API (v2). It wraps the OAuth-style token flow, institution discovery, end-user agreements, requisitions (the bank-linking consent flow), and account data retrieval (balances, details, transactions).

## Commits & PRs

This repo uses [Conventional Commits](https://www.conventionalcommits.org). Every commit message **and** pull request title must follow the `type(scope): description` format, e.g. `feat: add transaction pagination`, `fix(http): refresh token before expiry`, `docs: expand README usage`. Common types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`, `ci`.

## Commands

```shell
dart pub get                                        # install dependencies
dart analyze                                        # static analysis (package:lints/recommended)
dart format .                                        # format
dart test                                           # run all tests
dart test test/error_response_test.dart             # run a single test file
dart test test/httputils_test.dart -n 'test name'   # run a single test by name

# Regenerate json_serializable code after editing any model with @JsonSerializable:
dart run build_runner build --delete-conflicting-outputs
```

### Tests requiring live credentials

`test/gcbad_dart_test.dart` drives the real GoCardless **sandbox** end-to-end and requires the `GCBAD_ID` and `GCBAD_KEY` environment variables. It uses `puppeteer` to headlessly click through the bank-consent web flow (see `test/sandbox_client.dart`), so it needs network access and a browser. `test/error_response_test.dart` and `test/httputils_test.dart` are offline unit tests and need no credentials.

## Architecture

Three layers, from public API down to the wire:

1. **`GoCardlessBankAccountDataClient`** (`lib/src/gocardless_bank_account_data_client.dart`) — the public entry point. Constructed with `secretId`/`secretKey`. Provides ergonomic, overloaded methods (e.g. `getInstitutionById` vs `getInstitutionByMetadata`, `createAgreement` vs `createDefaultAgreement`) and orchestration helpers like `waitForRequisitionLink` (polls until status is `linked`) and `getAccounts` (fans out over a requisition's account IDs). It owns model-to-JSON encoding and `DateTime` → `yyyy-MM-dd` formatting; it delegates all HTTP to the web client.

2. **`GoCardlessHttpClient`** (`lib/src/gocardless_http_client.dart`) — one method per API endpoint. Holds the bearer `Token` and refreshes it via `_checkToken()` before every call (re-requests when missing or within 30s of expiry). Hardcodes the `https://bankaccountdata.gocardless.com/api/v2/` base URL. Returns parsed models.

3. **`GoCardlessHttpUtils`** (`lib/src/gocardless_http_utils.dart`) — the single parse/error chokepoint. `parse`/`parseList` UTF-8 decode `response.bodyBytes` (not `.body`, to handle non-ASCII) and run the model's `fromJson`. On any parse failure it re-interprets the body as an `ErrorResponse` and throws a **`GoCardlessException`** — so callers only ever see either a valid model or a `GoCardlessException`, never a raw HTTP/JSON error.

### Models & serialization

All models live in `lib/src/models/` and use `json_serializable`. Each hand-written `*.dart` has a generated `*.g.dart` sibling (`part` file) — **never edit `.g.dart` by hand**; edit the source and rerun `build_runner`. `build.yaml` sets `ignore_unannotated: true` and `include_if_null: false`. API field names are mapped with `@JsonKey(name: '...')`, and enum wire values with `@JsonValue` (e.g. `RequisitionStatus.linked` ↔ `'LN'`).

### Public surface

`lib/gcbad_dart.dart` is the barrel export — anything a consumer should use must be exported there. `lib/src/` is private-by-convention; note the client, exception, and models are exported, but `GoCardlessHttpClient`/`GoCardlessHttpUtils` are intentionally not.

### Error handling contract

Errors surface exclusively as `GoCardlessException` (`lib/src/gocardless_exception.dart`), built from GoCardless's error payload (`summary`/`detail`/`status_code`) by `ErrorResponse.exception` or the more defensive `ErrorResponse.createException` (which tolerates list-shaped `summary`/`detail` fields). When adding endpoints, always route responses through `GoCardlessHttpUtils` to preserve this contract.
