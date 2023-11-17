import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'created')
  final String? created;
  @JsonKey(name: 'last_accessed')
  final String? lastAccessed;
  @JsonKey(name: 'iban')
  final String? iban;
  @JsonKey(name: 'institution_id')
  final String institutionId;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'owner_name')
  final String? ownerName;

  Account(
      {required this.id,
      required this.created,
      required this.lastAccessed,
      required this.iban,
      required this.institutionId,
      required this.status,
      required this.ownerName});

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
