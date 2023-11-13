import 'package:json_annotation/json_annotation.dart';

part 'integration.g.dart';

@JsonSerializable()
class Integration {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'bic')
  final String? bic;
  @JsonKey(name: 'transaction_total_days')
  final String? transactionTotalDays;
  @JsonKey(name: 'countries')
  final List<String> countries;
  @JsonKey(name: 'logo')
  final String logo;

  Integration(
      {required this.id,
      required this.name,
      required this.bic,
      required this.transactionTotalDays,
      required this.countries,
      required this.logo});

  factory Integration.fromJson(Map<String, dynamic> json) =>
      _$IntegrationFromJson(json);

  Map<String, dynamic> toJson() => _$IntegrationToJson(this);
}
