import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: 'access')
  final String accessToken;
  @JsonKey(name: 'access_expires')
  final int accessExpiresSeconds;
  @JsonKey(name: 'refresh')
  final String refreshToken;
  @JsonKey(name: 'refresh_expires')
  final int refreshExpiresSeconds;

  Duration get accessExpires => Duration(seconds: accessExpiresSeconds);

  Duration get refreshExpires => Duration(seconds: refreshExpiresSeconds);

  Token({
    required this.accessToken,
    required this.accessExpiresSeconds,
    required this.refreshToken,
    required this.refreshExpiresSeconds,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
