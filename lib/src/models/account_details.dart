import 'package:json_annotation/json_annotation.dart';

part 'account_details.g.dart';

@JsonSerializable()
class AccountDetails {
  @JsonKey(name: 'account')
  final AccountDetailsInternal details;

  AccountDetails({required this.details});

  factory AccountDetails.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDetailsToJson(this);
}

@JsonSerializable()
class AccountDetailsInternal {
  @JsonKey(name: 'name')
  final String name;

  AccountDetailsInternal({required this.name});

  factory AccountDetailsInternal.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailsInternalFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDetailsInternalToJson(this);
}
