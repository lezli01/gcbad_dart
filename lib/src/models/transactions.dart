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

  Transaction(
      {required this.transactionId,
      required this.entryReference,
      required this.endToEndId,
      required this.mandateId,
      required this.checkId,
      required this.creditorId,
      required this.bookingDate,
      required this.valueDate,
      required this.bookingDateTime,
      required this.valueDateTime,
      required this.transactionAmount});

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
