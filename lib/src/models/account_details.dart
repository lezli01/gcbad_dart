import 'package:json_annotation/json_annotation.dart';

part 'account_details.g.dart';

@JsonSerializable()
class AccountDetails {
  @JsonKey(name: 'account')
  final AccountDetailsInternal account;

  AccountDetails({required this.account});

  factory AccountDetails.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDetailsToJson(this);
}

@JsonSerializable()
class AccountDetailsInternal {
  @JsonKey(name: 'resourceId')
  final String? resourceId;

  @JsonKey(name: 'iban')
  final String? iban;

  @JsonKey(name: 'bban')
  final String? bban;

  @JsonKey(name: 'msisdn')
  final String? msisdn;

  @JsonKey(name: 'currency')
  final String? currency;

  @JsonKey(name: 'ownerName')
  final String? ownerName;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'displayName')
  final String? displayName;

  @JsonKey(name: 'product')
  final String? product;

  @JsonKey(name: 'cashAccountType')
  final String? cashAccountType;

  @JsonKey(name: 'status')
  final String? status;

  @JsonKey(name: 'bic')
  final String? bic;

  @JsonKey(name: 'linkedAccounts')
  final String? linkedAccounts;

  @JsonKey(name: 'maskedPan')
  final String? maskedPan;

  @JsonKey(name: 'usage')
  final String? usage;

  @JsonKey(name: 'details')
  final String? details;

  @JsonKey(name: 'ownerAddressUnstructured')
  final String? ownerAddressUnstructured;

  @JsonKey(name: 'ownerAddressStructured')
  final OwnerAddressStructured? ownerAddressStructured;

  AccountDetailsInternal(
      {required this.resourceId,
      required this.iban,
      required this.bban,
      required this.msisdn,
      required this.currency,
      required this.ownerName,
      required this.name,
      required this.displayName,
      required this.product,
      required this.cashAccountType,
      required this.status,
      required this.bic,
      required this.linkedAccounts,
      required this.maskedPan,
      required this.usage,
      required this.details,
      required this.ownerAddressUnstructured,
      required this.ownerAddressStructured});

  factory AccountDetailsInternal.fromJson(Map<String, dynamic> json) =>
      _$AccountDetailsInternalFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDetailsInternalToJson(this);
}

@JsonSerializable()
class OwnerAddressStructured {
  @JsonKey(name: 'streetName')
  final String? streetName;

  @JsonKey(name: 'buildingNumber')
  final String? buildingNumber;

  @JsonKey(name: 'townName')
  final String? townName;

  @JsonKey(name: 'postCode')
  final String? postCode;

  @JsonKey(name: 'country')
  final String? country;

  OwnerAddressStructured(
      {required this.streetName,
      required this.buildingNumber,
      required this.townName,
      required this.postCode,
      required this.country});

  factory OwnerAddressStructured.fromJson(Map<String, dynamic> json) =>
      _$OwnerAddressStructuredFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerAddressStructuredToJson(this);
}
