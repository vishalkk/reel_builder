//domain connect to outside world using base use case
import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
