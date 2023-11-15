import 'package:json_annotation/json_annotation.dart';

part 'requisition_request.g.dart';

@JsonSerializable()
class RequisitionRequest {
  @JsonKey(name: 'redirect')
  final String redirectUrl;
  @JsonKey(name: 'institution_id')
  final String institutionId;
  @JsonKey(name: 'agreement')
  final String? agreementId;
  @JsonKey(name: 'reference')
  final String? reference;
  @JsonKey(name: 'user_language')
  final String? userLanguage;
  @JsonKey(name: 'ssn')
  final String? ssn;
  @JsonKey(name: 'account_selection')
  final bool? accountSelection;
  @JsonKey(name: 'redirect_immediate')
  final bool? redirectImmediate;

  RequisitionRequest(
      {required this.redirectUrl,
      required this.institutionId,
      required this.agreementId,
      required this.reference,
      required this.userLanguage,
      required this.ssn,
      required this.accountSelection,
      required this.redirectImmediate});

  RequisitionRequest.withDefaults(
      {required this.redirectUrl, required this.institutionId})
      : agreementId = null,
        reference = null,
        userLanguage = null,
        ssn = null,
        accountSelection = null,
        redirectImmediate = null;

  factory RequisitionRequest.fromJson(Map<String, dynamic> json) =>
      _$RequisitionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequisitionRequestToJson(this);
}
