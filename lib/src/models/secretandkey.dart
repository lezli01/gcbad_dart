import 'package:json_annotation/json_annotation.dart';

part 'secretandkey.g.dart';

@JsonSerializable()
class SecretAndKey {
  @JsonKey(name: 'secret_id')
  final String secretId;

  @JsonKey(name: 'secret_key')
  final String secretKey;

  SecretAndKey({required this.secretId, required this.secretKey});

  factory SecretAndKey.fromJson(Map<String, dynamic> json) =>
      _$SecretAndKeyFromJson(json);
  Map<String, dynamic> toJson() => _$SecretAndKeyToJson(this);
}
