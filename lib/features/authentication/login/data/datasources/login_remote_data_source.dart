import 'package:mis_mobile/features/authentication/login/data/models/request/login_request.dart';
import 'package:mis_mobile/features/authentication/login/data/models/response/login_response.dart';
import 'package:mis_mobile/features/authentication/login/data/network/login_api.dart';

abstract class RemoteLoginDataSource {
  Future<LoginResponse> login(LoginRequest loginRequest);
}

class RemoteLoginDataImplementer implements RemoteLoginDataSource {
  final LoginServiceClient _loginServiceClient;

  RemoteLoginDataImplementer(this._loginServiceClient);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _loginServiceClient.login(loginRequest);
  }
}
