import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: "country_code")
  final String countryCode;
  @JsonKey(name: "phone")
  final String phone;
  @JsonKey(name: "password")
  final String password;

  LoginRequest({
    required this.countryCode,
    required this.phone,
    required this.password,
  });

  /// Factory constructor for creating a new `LoginRequest` from a map.
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  /// Method to convert an instance into a map.
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
