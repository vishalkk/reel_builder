import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/error_handler.dart';
import 'package:mis_mobile/core/Network/failure.dart';
import 'package:mis_mobile/features/authentication/login/data/datasources/login_remote_data_source.dart';
import 'package:mis_mobile/features/authentication/login/data/models/request/login_request.dart';
import 'package:mis_mobile/features/authentication/login/data/models/response/login_response.dart';
import 'package:mis_mobile/features/authentication/login/domain/entities/user.dart';
import 'package:mis_mobile/features/authentication/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final RemoteLoginDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> login(LoginRequest request) async {
    try {
      // final LoginResponse response = await remoteDataSource.login(request);
      //
      // final user = User(
      //   message: response.msg ?? " ",
      //   phone: response.phone ?? " ",
      //   name: response.name ?? " ",
      //   id: response.id ?? "",
      //   accessToken: response.accessToken ?? " ",
      //   refreshToken: response.refreshToken ?? " ",
      //   expiresIn: response.expiresIn ?? 0,
      //   refreshExpiresIn: response.refreshExpiresIn ?? 0,
      // );
      final user = User(
        message: "Login successful",
        phone: request.phone,
        name: "Mock User",
        id: "mock-user-id-001",
        accessToken: "mock-access-token",
        refreshToken: "mock-refresh-token",
        expiresIn: 3600,
        refreshExpiresIn: 86400,
      );

      return Right(user);
    } catch (error) {
      // return left
      return (Left(ErrorHandler.handle(error).failure));
    }
  }
}
