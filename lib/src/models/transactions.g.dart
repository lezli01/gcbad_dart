// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transactions _$TransactionsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Transactions', json, ($checkedConvert) {
      final val = Transactions(
        transactions: $checkedConvert(
          'transactions',
          (v) => TransactionsInternal.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TransactionsToJson(Transactions instance) =>
    <String, dynamic>{'transactions': instance.transactions};

TransactionsInternal _$TransactionsInternalFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('TransactionsInternal', json, ($checkedConvert) {
  final val = TransactionsInternal(
    booked: $checkedConvert(
      'booked',
      (v) => (v as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    pending: $checkedConvert(
      'pending',
      (v) => (v as List<dynamic>)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$TransactionsInternalToJson(
  TransactionsInternal instance,
) => <String, dynamic>{'booked': instance.booked, 'pending': instance.pending};

Transaction _$TransactionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Transaction', json, ($checkedConvert) {
  final val = Transaction(
    transactionId: $checkedConvert('transactionId', (v) => v as String?),
    entryReference: $checkedConvert('entryReference', (v) => v as String?),
    endToEndId: $checkedConvert('endToEndId', (v) => v as String?),
    mandateId: $checkedConvert('mandateId', (v) => v as String?),
    checkId: $checkedConvert('checkId', (v) => v as String?),
    creditorId: $checkedConvert('creditorId', (v) => v as String?),
    bookingDate: $checkedConvert('bookingDate', (v) => v as String?),
    valueDate: $checkedConvert('valueDate', (v) => v as String?),
    bookingDateTime: $checkedConvert('bookingDateTime', (v) => v as String?),
    valueDateTime: $checkedConvert('valueDateTime', (v) => v as String?),
    transactionAmount: $checkedConvert(
      'transactionAmount',
      (v) => TransactionAmount.fromJson(v as Map<String, dynamic>),
    ),
    currencyExchange: $checkedConvert(
      'currencyExchange',
      (v) => v == null
          ? null
          : CurrencyExchange.fromJson(v as Map<String, dynamic>),
    ),
    creditorName: $checkedConvert('creditorName', (v) => v as String?),
    creditorAccount: $checkedConvert(
      'creditorAccount',
      (v) => v == null ? null : AccountInfo.fromJson(v as Map<String, dynamic>),
    ),
    ultimateCreditor: $checkedConvert('ultimateCreditor', (v) => v as String?),
    debtorName: $checkedConvert('debtorName', (v) => v as String?),
    debtorAccount: $checkedConvert(
      'debtorAccount',
      (v) => v == null ? null : AccountInfo.fromJson(v as Map<String, dynamic>),
    ),
    ultimateDebtor: $checkedConvert('ultimateDebtor', (v) => v as String?),
    remittanceInformationUnstructured: $checkedConvert(
      'remittanceInformationUnstructured',
      (v) => v as String?,
    ),
    remittanceInformationUnstructuredArray: $checkedConvert(
      'remittanceInformationUnstructuredArray',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
    ),
    remittanceInformationStructured: $checkedConvert(
      'remittanceInformationStructured',
      (v) => v as String?,
    ),
    remittanceInformationStructuredArray: $checkedConvert(
      'remittanceInformationStructuredArray',
      (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
    ),
    additionalInformation: $checkedConvert(
      'additionalInformation',
      (v) => v as String?,
    ),
    purposeCode: $checkedConvert('purposeCode', (v) => v as String?),
    bankTransactionCode: $checkedConvert(
      'bankTransactionCode',
      (v) => v as String?,
    ),
    proprietaryBankTransactionCode: $checkedConvert(
      'proprietaryBankTransactionCode',
      (v) => v as String?,
    ),
    internalTransactionId: $checkedConvert(
      'internalTransactionId',
      (v) => v as String?,
    ),
  );
  return val;
});

Map<String, dynamic> _$TransactionToJson(
  Transaction instance,
) => <String, dynamic>{
  'transactionId': ?instance.transactionId,
  'entryReference': ?instance.entryReference,
  'endToEndId': ?instance.endToEndId,
  'mandateId': ?instance.mandateId,
  'checkId': ?instance.checkId,
  'creditorId': ?instance.creditorId,
  'bookingDate': ?instance.bookingDate,
  'valueDate': ?instance.valueDate,
  'bookingDateTime': ?instance.bookingDateTime,
  'valueDateTime': ?instance.valueDateTime,
  'transactionAmount': instance.transactionAmount,
  'currencyExchange': ?instance.currencyExchange,
  'creditorName': ?instance.creditorName,
  'creditorAccount': ?instance.creditorAccount,
  'ultimateCreditor': ?instance.ultimateCreditor,
  'debtorName': ?instance.debtorName,
  'debtorAccount': ?instance.debtorAccount,
  'ultimateDebtor': ?instance.ultimateDebtor,
  'remittanceInformationUnstructured':
      ?instance.remittanceInformationUnstructured,
  'remittanceInformationUnstructuredArray':
      ?instance.remittanceInformationUnstructuredArray,
  'remittanceInformationStructured': ?instance.remittanceInformationStructured,
  'remittanceInformationStructuredArray':
      ?instance.remittanceInformationStructuredArray,
  'additionalInformation': ?instance.additionalInformation,
  'purposeCode': ?instance.purposeCode,
  'bankTransactionCode': ?instance.bankTransactionCode,
  'proprietaryBankTransactionCode': ?instance.proprietaryBankTransactionCode,
  'internalTransactionId': ?instance.internalTransactionId,
};

TransactionAmount _$TransactionAmountFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TransactionAmount', json, ($checkedConvert) {
      final val = TransactionAmount(
        amount: $checkedConvert('amount', (v) => v as String),
        currency: $checkedConvert('currency', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$TransactionAmountToJson(TransactionAmount instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};

CurrencyExchange _$CurrencyExchangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CurrencyExchange', json, ($checkedConvert) {
      final val = CurrencyExchange(
        sourceCurrency: $checkedConvert('sourceCurrency', (v) => v as String?),
        exchangeRate: $checkedConvert('exchangeRate', (v) => v as String?),
        unitCurrency: $checkedConvert('unitCurrency', (v) => v as String?),
        targetCurrency: $checkedConvert('targetCurrency', (v) => v as String?),
        quotationDate: $checkedConvert('quotationDate', (v) => v as String?),
        contractIdentification: $checkedConvert(
          'contractIdentification',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$CurrencyExchangeToJson(CurrencyExchange instance) =>
    <String, dynamic>{
      'sourceCurrency': ?instance.sourceCurrency,
      'exchangeRate': ?instance.exchangeRate,
      'unitCurrency': ?instance.unitCurrency,
      'targetCurrency': ?instance.targetCurrency,
      'quotationDate': ?instance.quotationDate,
      'contractIdentification': ?instance.contractIdentification,
    };

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AccountInfo', json, ($checkedConvert) {
      final val = AccountInfo(
        iban: $checkedConvert('iban', (v) => v as String?),
        bban: $checkedConvert('bban', (v) => v as String?),
        pan: $checkedConvert('pan', (v) => v as String?),
        maskedPan: $checkedConvert('maskedPan', (v) => v as String?),
        msisdn: $checkedConvert('msisdn', (v) => v as String?),
        currency: $checkedConvert('currency', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'iban': ?instance.iban,
      'bban': ?instance.bban,
      'pan': ?instance.pan,
      'maskedPan': ?instance.maskedPan,
      'msisdn': ?instance.msisdn,
      'currency': ?instance.currency,
    };
