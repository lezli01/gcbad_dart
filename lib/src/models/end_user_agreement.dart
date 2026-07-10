import 'package:gcbad_dart/src/models/information_to_access.dart';
import 'package:json_annotation/json_annotation.dart';

part 'end_user_agreement.g.dart';

@JsonSerializable()
class EndUserAgreement {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'created')
  final String? created;
  @JsonKey(name: 'institution_id')
  final String institutionId;
  @JsonKey(name: 'max_historical_days')
  final int maxHistoricalDays;
  @JsonKey(name: 'access_valid_for_days')
  final int accessValidForDays;
  @JsonKey(name: 'access_scope')
  final List<InformationToAccess>? accessScope;
  @JsonKey(name: 'accepted')
  final String? accepted;

  EndUserAgreement({
    required this.id,
    required this.created,
    required this.institutionId,
    required this.maxHistoricalDays,
    required this.accessValidForDays,
    required this.accessScope,
    required this.accepted,
  });

  factory EndUserAgreement.fromJson(Map<String, dynamic> json) =>
      _$EndUserAgreementFromJson(json);

  Map<String, dynamic> toJson() => _$EndUserAgreementToJson(this);
}
