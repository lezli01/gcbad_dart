import 'package:gcbad_dart/src/models/institution_feature.dart';
import 'package:gcbad_dart/src/models/institution_metadata.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gcbad_dart/src/gocardless_country_code.dart';

part 'institution.g.dart';

@JsonSerializable()
class Institution extends InstitutionMetadata {
  @JsonKey(name: 'supported_features')
  final List<InstitutionFeature> supportedFeatures;
  @JsonKey(name: 'identification_codes')
  final List<String> identificationCodes;

  Institution(
      {required this.supportedFeatures,
      required this.identificationCodes,
      required super.id,
      required super.name,
      required super.bic,
      required super.transactionTotalDays,
      required super.countries,
      required super.logo});

  factory Institution.fromJson(Map<String, dynamic> json) =>
      _$InstitutionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InstitutionToJson(this);
}
