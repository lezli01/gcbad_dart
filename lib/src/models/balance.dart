import 'package:json_annotation/json_annotation.dart';

part 'balance.g.dart';

@JsonSerializable()
class Balance {
  @JsonKey(name: 'balanceAmount')
  final BalanceAmount balanceAmount;

  @JsonKey(name: 'balanceType')
  final String balanceType;

  @JsonKey(name: 'creditLimitIncluded')
  final bool? creditLimitIncluded;

  @JsonKey(name: 'lastChangeDateTime')
  final String? lastChangeDateTime;

  @JsonKey(name: 'referenceDate')
  final String? referenceDate;

  @JsonKey(name: 'lastCommittedTransaction')
  final String? lastCommittedTransaction;

  Balance(
      {required this.balanceAmount,
      required this.balanceType,
      required this.creditLimitIncluded,
      required this.lastChangeDateTime,
      required this.referenceDate,
      required this.lastCommittedTransaction});

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}

@JsonSerializable()
class BalanceAmount {
  @JsonKey(name: 'amount')
  final String amount;

  @JsonKey(name: 'currency')
  final String currency;

  BalanceAmount({required this.amount, required this.currency});

  factory BalanceAmount.fromJson(Map<String, dynamic> json) =>
      _$BalanceAmountFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceAmountToJson(this);
}
