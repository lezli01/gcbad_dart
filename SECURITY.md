# Security Policy

## Supported versions

Security fixes are provided for the most recent release of `gcbad_dart` (the
`1.x` line). Please make sure you are on the latest version before reporting an
issue.

| Version | Supported          |
| ------- | ------------------ |
| 1.x     | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues,
discussions, or pull requests.**

Instead, report them privately through GitHub:

1. Open the [**Security** tab](https://github.com/lezli01/gcbad_dart/security)
   of this repository.
2. Click **Report a vulnerability** to start a private advisory that is visible
   only to the maintainers.

Please include as much of the following as you can:

- The type of issue and the affected component (token handling, the HTTP layer,
  a specific model, etc.).
- Steps to reproduce, or a proof of concept.
- The impact — how an attacker might exploit the issue.
- Any known mitigations or workarounds.

You can expect an initial acknowledgement within a few business days. We will
keep you informed of progress toward a fix and coordinate disclosure once a
patch is available.

## Handling credentials

`gcbad_dart` authenticates to the GoCardless Bank Account Data API with a
**secret ID** and **secret key**. Treat these as sensitive:

- Never hard-code them in source or commit them to version control — load them
  from environment variables or a secret manager.
- The test suite reads sandbox credentials from the `GCBAD_ID` / `GCBAD_KEY`
  environment variables; keep those out of the repository and out of CI logs.

This repository runs automated secret scanning — GitHub secret scanning with
push protection, plus a [gitleaks](.github/workflows/gitleaks.yml) workflow — to
help catch accidentally committed credentials.
