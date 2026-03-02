import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/failure.dart';
import 'package:mis_mobile/features/authentication/login/data/models/request/login_request.dart';
import 'package:mis_mobile/features/authentication/login/domain/entities/user.dart';
import 'package:mis_mobile/features/authentication/login/domain/repositories/login_repository.dart';
import 'package:mis_mobile/features/common/base_usecase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, User> {
  final LoginRepository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> execute(LoginUseCaseInput input) async {
    return await _repository.login(LoginRequest(
      countryCode: input.countryCode,
      phone: input.phoneNumber,
      password: input.password,
    ));
  }
}

class LoginUseCaseInput {
  String countryCode;
  String password;
  String phoneNumber;
  LoginUseCaseInput(this.countryCode, this.phoneNumber, this.password);
}
