import 'package:dartz/dartz.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';
import 'package:mis_mobile/core/Network/error_mapper.dart';
import 'package:mis_mobile/features/template_use/data/datasources/template_use_remote_data_source.dart';
import 'package:mis_mobile/features/template_use/domain/entities/template_use_request.dart';
import 'package:mis_mobile/features/template_use/domain/repositories/template_use_repository.dart';

class TemplateUseRepositoryImpl implements TemplateUseRepository {
  final TemplateUseRemoteDataSource remoteDataSource;

  const TemplateUseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<ApiFailure, RenderSubmissionAcceptedResponse>> createSubmission(
    RenderSubmissionCreateRequest request,
  ) async {
    try {
      final response = await remoteDataSource.createSubmission(request);
      return Right(response);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<ApiFailure, RenderSubmissionStatusResponse>>
      getSubmissionStatus(
    String submissionId,
  ) async {
    try {
      final response = await remoteDataSource.getSubmissionStatus(submissionId);
      return Right(response);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
