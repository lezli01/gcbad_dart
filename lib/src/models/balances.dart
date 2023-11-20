import 'package:gcbad_dart/src/models/balance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'balances.g.dart';

@JsonSerializable()
class Balances {
  @JsonKey(name: 'balances')
  final List<Balance> balances;

  Balances({required this.balances});

  factory Balances.fromJson(Map<String, dynamic> json) =>
      _$BalancesFromJson(json);

  Map<String, dynamic> toJson() => _$BalancesToJson(this);
}
