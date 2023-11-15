import 'package:json_annotation/json_annotation.dart';

enum InformationToAccess {
  @JsonValue('balances')
  balances,
  @JsonValue('details')
  details,
  @JsonValue('transactions')
  transactions
}
