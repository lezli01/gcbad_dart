import 'package:json_annotation/json_annotation.dart';

part 'institution.g.dart';

@JsonSerializable()
class Institution {
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

  Institution(
      {required this.id,
      required this.name,
      required this.bic,
      required this.transactionTotalDays,
      required this.countries,
      required this.logo});

  factory Institution.fromJson(Map<String, dynamic> json) =>
      _$InstitutionFromJson(json);

  Map<String, dynamic> toJson() => _$InstitutionToJson(this);
}
