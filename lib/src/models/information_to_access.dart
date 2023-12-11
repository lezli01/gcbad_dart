import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'code')
enum InformationToAccess {
  balances('balances'),
  details('details'),
  transactions('transactions');

  const InformationToAccess(this.code);

  final String code;
}
