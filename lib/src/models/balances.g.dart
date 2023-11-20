// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balances.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Balances _$BalancesFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Balances',
      json,
      ($checkedConvert) {
        final val = Balances(
          balances: $checkedConvert(
              'balances',
              (v) => (v as List<dynamic>)
                  .map((e) => Balance.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$BalancesToJson(Balances instance) => <String, dynamic>{
      'balances': instance.balances,
    };
