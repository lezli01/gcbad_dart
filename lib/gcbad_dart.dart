/// A Dart client for the [GoCardless Bank Account Data][] API (v2).
///
/// Wraps the token flow, institution discovery, end-user agreements,
/// requisitions (the bank-linking consent flow), and account data retrieval
/// (balances, details, transactions). Start from
/// [GoCardlessBankAccountDataClient].
///
/// [GoCardless Bank Account Data]: https://bankaccountdata.gocardless.com
library;

export 'src/gocardless_bank_account_data_client.dart';
export 'src/gocardless_country_code.dart';
export 'src/gocardless_exception.dart';

export 'src/models/account.dart';
export 'src/models/account_details.dart';
export 'src/models/balance.dart';
export 'src/models/balances.dart';
export 'src/models/error_response.dart';
export 'src/models/end_user_agreement.dart';
export 'src/models/end_user_agreement_request.dart';
export 'src/models/information_to_access.dart';
export 'src/models/institution.dart';
export 'src/models/institution_feature.dart';
export 'src/models/institution_metadata.dart';
export 'src/models/requisition.dart';
export 'src/models/requisition_request.dart';
export 'src/models/secretandkey.dart';
export 'src/models/token.dart';
export 'src/models/transactions.dart';
