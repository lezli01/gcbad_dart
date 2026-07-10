import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum InstitutionFeature {
  submitPayment('submit_payment'),
  payments('payments'),
  pendingTransactions('pending_transactions'),
  readDebtorAccount('read_debtor_account'),
  readRefundAccount('read_refund_account'),
  cardAccounts('card_accounts'),
  privateAccounts('private_accounts'),
  businessAccounts('business_accounts'),
  corporateAccounts('corporate_accounts'),
  ssnVerification('ssn_verification'),
  accountSelection('account_selection'),

  /// Fallback for feature codes GoCardless returns that this enum does not yet
  /// model (the API adds features over time, e.g. `reconfirmation_of_consent`).
  /// Deserialization maps any unrecognized code here instead of failing — see
  /// the `unknownEnumValue` on `Institution.supportedFeatures`.
  unknown('unknown');

  const InstitutionFeature(this.code);

  final String code;
}
