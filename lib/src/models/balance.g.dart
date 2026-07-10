// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balance _$BalanceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Balance', json, ($checkedConvert) {
      final val = Balance(
        balanceAmount: $checkedConvert(
          'balanceAmount',
          (v) => BalanceAmount.fromJson(v as Map<String, dynamic>),
        ),
        balanceType: $checkedConvert('balanceType', (v) => v as String),
        creditLimitIncluded: $checkedConvert(
          'creditLimitIncluded',
          (v) => v as bool?,
        ),
        lastChangeDateTime: $checkedConvert(
          'lastChangeDateTime',
          (v) => v as String?,
        ),
        referenceDate: $checkedConvert('referenceDate', (v) => v as String?),
        lastCommittedTransaction: $checkedConvert(
          'lastCommittedTransaction',
          (v) => v as String?,
        ),
      );
      return val;
    });

Map<String, dynamic> _$BalanceToJson(Balance instance) => <String, dynamic>{
  'balanceAmount': instance.balanceAmount,
  'balanceType': instance.balanceType,
  'creditLimitIncluded': ?instance.creditLimitIncluded,
  'lastChangeDateTime': ?instance.lastChangeDateTime,
  'referenceDate': ?instance.referenceDate,
  'lastCommittedTransaction': ?instance.lastCommittedTransaction,
};

BalanceAmount _$BalanceAmountFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BalanceAmount', json, ($checkedConvert) {
      final val = BalanceAmount(
        amount: $checkedConvert('amount', (v) => v as String),
        currency: $checkedConvert('currency', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$BalanceAmountToJson(BalanceAmount instance) =>
    <String, dynamic>{'amount': instance.amount, 'currency': instance.currency};
