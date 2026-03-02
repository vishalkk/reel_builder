// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: json['id'] as String?,
      name: json['name'] as String?,
      msg: json['msg'] as String?,
      phone: json['phone'] as String?,
      refreshToken: json['refresh_token'] as String?,
      accessToken: json['access_token'] as String?,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      refreshExpiresIn: (json['refresh_expires_in'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'msg': instance.msg,
      'phone': instance.phone,
      'refresh_token': instance.refreshToken,
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'refresh_expires_in': instance.refreshExpiresIn,
    };
