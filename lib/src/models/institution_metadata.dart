import 'package:gcbad_dart/src/gocardless_country_code.dart';
import 'package:json_annotation/json_annotation.dart';

part 'institution_metadata.g.dart';

@JsonSerializable()
class InstitutionMetadata {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'bic')
  final String? bic;
  @JsonKey(name: 'transaction_total_days')
  final String? transactionTotalDays;
  // Map country codes GoCardless returns that this enum does not model (its
  // coverage grows over time) to `invalid` instead of failing the whole parse.
  @JsonKey(name: 'countries', unknownEnumValue: GoCardlessCountryCode.invalid)
  final List<GoCardlessCountryCode> countries;
  @JsonKey(name: 'logo')
  final String logo;

  InstitutionMetadata({
    required this.id,
    required this.name,
    required this.bic,
    required this.transactionTotalDays,
    required this.countries,
    required this.logo,
  });

  factory InstitutionMetadata.fromJson(Map<String, dynamic> json) =>
      _$InstitutionMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$InstitutionMetadataToJson(this);
}
