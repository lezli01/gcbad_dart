// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transactions _$TransactionsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Transactions',
      json,
      ($checkedConvert) {
        final val = Transactions(
          transactions: $checkedConvert('transactions',
              (v) => TransactionsInternal.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$TransactionsToJson(Transactions instance) =>
    <String, dynamic>{
      'transactions': instance.transactions,
    };

TransactionsInternal _$TransactionsInternalFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'TransactionsInternal',
      json,
      ($checkedConvert) {
        final val = TransactionsInternal(
          booked: $checkedConvert(
              'booked',
              (v) => (v as List<dynamic>)
                  .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
                  .toList()),
          pending: $checkedConvert(
              'pending',
              (v) => (v as List<dynamic>)
                  .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$TransactionsInternalToJson(
        TransactionsInternal instance) =>
    <String, dynamic>{
      'booked': instance.booked,
      'pending': instance.pending,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Transaction',
      json,
      ($checkedConvert) {
        final val = Transaction(
          transactionId: $checkedConvert('transactionId', (v) => v as String?),
          entryReference:
              $checkedConvert('entryReference', (v) => v as String?),
          endToEndId: $checkedConvert('endToEndId', (v) => v as String?),
          mandateId: $checkedConvert('mandateId', (v) => v as String?),
          checkId: $checkedConvert('checkId', (v) => v as String?),
          creditorId: $checkedConvert('creditorId', (v) => v as String?),
          bookingDate: $checkedConvert('bookingDate', (v) => v as String?),
          valueDate: $checkedConvert('valueDate', (v) => v as String?),
          bookingDateTime:
              $checkedConvert('bookingDateTime', (v) => v as String?),
          valueDateTime: $checkedConvert('valueDateTime', (v) => v as String?),
          transactionAmount: $checkedConvert('transactionAmount',
              (v) => TransactionAmount.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('transactionId', instance.transactionId);
  writeNotNull('entryReference', instance.entryReference);
  writeNotNull('endToEndId', instance.endToEndId);
  writeNotNull('mandateId', instance.mandateId);
  writeNotNull('checkId', instance.checkId);
  writeNotNull('creditorId', instance.creditorId);
  writeNotNull('bookingDate', instance.bookingDate);
  writeNotNull('valueDate', instance.valueDate);
  writeNotNull('bookingDateTime', instance.bookingDateTime);
  writeNotNull('valueDateTime', instance.valueDateTime);
  val['transactionAmount'] = instance.transactionAmount;
  return val;
}

TransactionAmount _$TransactionAmountFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TransactionAmount',
      json,
      ($checkedConvert) {
        final val = TransactionAmount(
          amount: $checkedConvert('amount', (v) => v as String),
          currency: $checkedConvert('currency', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$TransactionAmountToJson(TransactionAmount instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
    };
