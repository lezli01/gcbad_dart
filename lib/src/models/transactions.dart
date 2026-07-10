import 'package:json_annotation/json_annotation.dart';

part 'transactions.g.dart';

@JsonSerializable()
class Transactions {
  @JsonKey(name: 'transactions')
  final TransactionsInternal transactions;

  Transactions({required this.transactions});

  factory Transactions.fromJson(Map<String, dynamic> json) =>
      _$TransactionsFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsToJson(this);
}

@JsonSerializable()
class TransactionsInternal {
  @JsonKey(name: 'booked')
  final List<Transaction> booked;

  @JsonKey(name: 'pending')
  final List<Transaction> pending;

  TransactionsInternal({required this.booked, required this.pending});

  factory TransactionsInternal.fromJson(Map<String, dynamic> json) =>
      _$TransactionsInternalFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionsInternalToJson(this);
}

@JsonSerializable()
class Transaction {
  @JsonKey(name: 'transactionId')
  final String? transactionId;

  @JsonKey(name: 'entryReference')
  final String? entryReference;

  @JsonKey(name: 'endToEndId')
  final String? endToEndId;

  @JsonKey(name: 'mandateId')
  final String? mandateId;

  @JsonKey(name: 'checkId')
  final String? checkId;

  @JsonKey(name: 'creditorId')
  final String? creditorId;

  @JsonKey(name: 'bookingDate')
  final String? bookingDate;

  @JsonKey(name: 'valueDate')
  final String? valueDate;

  @JsonKey(name: 'bookingDateTime')
  final String? bookingDateTime;

  @JsonKey(name: 'valueDateTime')
  final String? valueDateTime;

  @JsonKey(name: 'transactionAmount')
  final TransactionAmount transactionAmount;

  @JsonKey(name: 'currencyExchange')
  final CurrencyExchange? currencyExchange;

  @JsonKey(name: 'creditorName')
  final String? creditorName;

  @JsonKey(name: 'creditorAccount')
  final AccountInfo? creditorAccount;

  @JsonKey(name: 'ultimateCreditor')
  final String? ultimateCreditor;

  @JsonKey(name: 'debtorName')
  final String? debtorName;

  @JsonKey(name: 'debtorAccount')
  final AccountInfo? debtorAccount;

  @JsonKey(name: 'ultimateDebtor')
  final String? ultimateDebtor;

  @JsonKey(name: 'remittanceInformationUnstructured')
  final String? remittanceInformationUnstructured;

  @JsonKey(name: 'remittanceInformationUnstructuredArray')
  final List<String>? remittanceInformationUnstructuredArray;

  @JsonKey(name: 'remittanceInformationStructured')
  final String? remittanceInformationStructured;

  @JsonKey(name: 'remittanceInformationStructuredArray')
  final List<String>? remittanceInformationStructuredArray;

  @JsonKey(name: 'additionalInformation')
  final String? additionalInformation;

  @JsonKey(name: 'purposeCode')
  final String? purposeCode;

  @JsonKey(name: 'bankTransactionCode')
  final String? bankTransactionCode;

  @JsonKey(name: 'proprietaryBankTransactionCode')
  final String? proprietaryBankTransactionCode;

  @JsonKey(name: 'internalTransactionId')
  final String? internalTransactionId;

  Transaction({
    required this.transactionId,
    required this.entryReference,
    required this.endToEndId,
    required this.mandateId,
    required this.checkId,
    required this.creditorId,
    required this.bookingDate,
    required this.valueDate,
    required this.bookingDateTime,
    required this.valueDateTime,
    required this.transactionAmount,
    required this.currencyExchange,
    required this.creditorName,
    required this.creditorAccount,
    required this.ultimateCreditor,
    required this.debtorName,
    required this.debtorAccount,
    required this.ultimateDebtor,
    required this.remittanceInformationUnstructured,
    required this.remittanceInformationUnstructuredArray,
    required this.remittanceInformationStructured,
    required this.remittanceInformationStructuredArray,
    required this.additionalInformation,
    required this.purposeCode,
    required this.bankTransactionCode,
    required this.proprietaryBankTransactionCode,
    required this.internalTransactionId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class TransactionAmount {
  @JsonKey(name: 'amount')
  final String amount;
  @JsonKey(name: 'currency')
  final String currency;

  TransactionAmount({required this.amount, required this.currency});

  factory TransactionAmount.fromJson(Map<String, dynamic> json) =>
      _$TransactionAmountFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionAmountToJson(this);
}

@JsonSerializable()
class CurrencyExchange {
  @JsonKey(name: 'sourceCurrency')
  final String? sourceCurrency;

  @JsonKey(name: 'exchangeRate')
  final String? exchangeRate;

  @JsonKey(name: 'unitCurrency')
  final String? unitCurrency;

  @JsonKey(name: 'targetCurrency')
  final String? targetCurrency;

  @JsonKey(name: 'quotationDate')
  final String? quotationDate;

  @JsonKey(name: 'contractIdentification')
  final String? contractIdentification;

  CurrencyExchange({
    required this.sourceCurrency,
    required this.exchangeRate,
    required this.unitCurrency,
    required this.targetCurrency,
    required this.quotationDate,
    required this.contractIdentification,
  });

  factory CurrencyExchange.fromJson(Map<String, dynamic> json) =>
      _$CurrencyExchangeFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyExchangeToJson(this);
}

@JsonSerializable()
class AccountInfo {
  @JsonKey(name: 'iban')
  final String? iban;

  @JsonKey(name: 'bban')
  final String? bban;

  @JsonKey(name: 'pan')
  final String? pan;

  @JsonKey(name: 'maskedPan')
  final String? maskedPan;

  @JsonKey(name: 'msisdn')
  final String? msisdn;

  @JsonKey(name: 'currency')
  final String? currency;

  AccountInfo({
    required this.iban,
    required this.bban,
    required this.pan,
    required this.maskedPan,
    required this.msisdn,
    required this.currency,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}
