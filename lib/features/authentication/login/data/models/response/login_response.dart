import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String? id;

  final String? name;

  final String? msg;

  final String? phone;

  @JsonKey(name: "refresh_token")
  final String? refreshToken;

  @JsonKey(name: "access_token")
  final String? accessToken;

  @JsonKey(name: "expires_in")
  final int? expiresIn;

  @JsonKey(name: "refresh_expires_in")
  final int? refreshExpiresIn;

  LoginResponse({
    this.id,
    this.name,
    this.msg,
    this.phone,
    this.refreshToken,
    this.accessToken,
    this.expiresIn,
    this.refreshExpiresIn,
  });

  /// fromJson
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  /// toJson
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
