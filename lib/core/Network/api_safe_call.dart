import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/error_handler.dart';
import 'package:mis_mobile/core/Network/failure.dart';
import 'package:mis_mobile/core/Network/network_info.dart';

Future<Either<Failure, T>> apiSafeCall<T>(
  NetworkInfo networkInfo,
  Future<T> Function() apiCall,
) async {
  try {
    final response = await apiCall();
    return Right(response);
  } catch (error) {
    return Left(
      ErrorHandler.handle(error).failure,
    );
  }
}
