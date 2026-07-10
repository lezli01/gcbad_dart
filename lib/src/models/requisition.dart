import 'package:json_annotation/json_annotation.dart';

part 'requisition.g.dart';

enum RequisitionStatus {
  @JsonValue('CR')
  created,
  @JsonValue('GC')
  givingConsent,
  @JsonValue('UA')
  undergoingAuthentication,
  @JsonValue('RJ')
  rejected,
  @JsonValue('SA')
  selectingAccounts,
  @JsonValue('GA')
  grantingAccess,
  @JsonValue('LN')
  linked,
  @JsonValue('EX')
  expired,
}

@JsonSerializable()
class Requisition {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'created')
  final String? created;
  @JsonKey(name: 'redirect')
  final String redirect;
  @JsonKey(name: 'status')
  final RequisitionStatus? status;
  @JsonKey(name: 'institution_id')
  final String institutionId;
  @JsonKey(name: 'agreement')
  final String? agreement;
  @JsonKey(name: 'reference')
  final String? reference;
  @JsonKey(name: 'accounts')
  final List<String>? accounts;
  @JsonKey(name: 'user_language')
  final String? userLanguage;
  @JsonKey(name: 'link')
  final String link;
  @JsonKey(name: 'ssn')
  final String? ssn;
  @JsonKey(name: 'account_selection')
  final bool? accountSelection;
  @JsonKey(name: 'redirect_immediate')
  final bool? redirectImmediate;

  Requisition({
    required this.id,
    required this.created,
    required this.redirect,
    required this.status,
    required this.institutionId,
    required this.agreement,
    required this.reference,
    required this.accounts,
    required this.userLanguage,
    required this.link,
    required this.ssn,
    required this.accountSelection,
    required this.redirectImmediate,
  });

  factory Requisition.fromJson(Map<String, dynamic> json) =>
      _$RequisitionFromJson(json);

  Map<String, dynamic> toJson() => _$RequisitionToJson(this);
}
