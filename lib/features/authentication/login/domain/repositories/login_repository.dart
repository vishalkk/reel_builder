import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/failure.dart';
import 'package:mis_mobile/features/authentication/login/data/models/request/login_request.dart';
import 'package:mis_mobile/features/authentication/login/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> login(LoginRequest request);
}
