# Changelog

## [1.0.1](https://github.com/lezli01/gcbad_dart/compare/v1.0.0...v1.0.1) (2026-07-10)


### Bug Fixes

* always surface GoCardlessException from parse chokepoint ([d1a1d1d](https://github.com/lezli01/gcbad_dart/commit/d1a1d1d2f571baa3815a4794b58d5ad29483ece2))
* make InstitutionMetadata.logo nullable ([cff927f](https://github.com/lezli01/gcbad_dart/commit/cff927fb7cf89007ec960c9db35c881af0c17871))
* regenerate Institution serialization for nullable logo ([764a498](https://github.com/lezli01/gcbad_dart/commit/764a498ab1e81721492f4b32ea45da0818633a96))
* tolerate unknown institution feature and country codes ([4e66313](https://github.com/lezli01/gcbad_dart/commit/4e66313665704cdb2c1f498358e6b521aee087cc))

## 1.0.0

- Initial release.
- `GoCardlessBankAccountDataClient` covering the GoCardless Bank Account Data
  API v2: institution discovery, end-user agreements, requisitions, and
  retrieval of accounts, balances, account details, and transactions.
- Automatic access-token management with transparent refresh.
- Unified error handling via `GoCardlessException`.
