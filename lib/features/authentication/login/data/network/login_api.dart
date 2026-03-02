import 'package:dio/dio.dart';
import 'package:mis_mobile/features/authentication/login/data/models/request/login_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:mis_mobile/features/authentication/login/data/models/response/login_response.dart';

part 'login_api.g.dart';

@RestApi()
abstract class LoginServiceClient {
  factory LoginServiceClient(Dio dio, {String baseUrl}) = _LoginServiceClient;

  @POST("/login/user-login")
  Future<LoginResponse> login(@Body() LoginRequest request);
}
