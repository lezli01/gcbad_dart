import 'package:json_annotation/json_annotation.dart';

import 'information_to_access.dart';

part 'end_user_agreement_request.g.dart';

@JsonSerializable()
class EndUserAgreementRequest {
  @JsonKey(name: 'institution_id')
  final String institutionId;
  @JsonKey(name: 'max_historical_days')
  final int? maxHistoricalDays;
  @JsonKey(name: 'access_valid_for_days')
  final int? accessValidForDays;
  @JsonKey(name: 'access_scope')
  final List<InformationToAccess>? accessScope;

  EndUserAgreementRequest(
      {required this.institutionId,
      required this.maxHistoricalDays,
      required this.accessValidForDays,
      required this.accessScope});

  EndUserAgreementRequest.withDefaults({required this.institutionId})
      : maxHistoricalDays = null,
        accessValidForDays = null,
        accessScope = null;

  factory EndUserAgreementRequest.fromJson(Map<String, dynamic> json) =>
      _$EndUserAgreementRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EndUserAgreementRequestToJson(this);
}
