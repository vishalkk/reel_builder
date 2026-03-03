import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mis_mobile/core/Network/api_failure.dart';

class ErrorMapper {
  const ErrorMapper._();

  static ApiFailure map(Object error) {
    if (error is DioException) {
      return _mapDioError(error);
    }

    if (error is FormatException) {
      return const ParsingFailure('Unable to parse response payload.');
    }

    return UnknownFailure(error.toString());
  }

  static ApiFailure _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Request timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection.');
      case DioExceptionType.cancel:
        return const NetworkFailure('Request cancelled.');
      case DioExceptionType.badCertificate:
        return const UnknownFailure('Bad certificate received.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractMessage(error.response?.data) ??
            'Request failed with status code $statusCode.';

        if (statusCode == HttpStatus.unauthorized ||
            statusCode == HttpStatus.forbidden) {
          return UnauthorizedFailure(message, statusCode: statusCode);
        }

        if (statusCode == HttpStatus.notFound) {
          return NotFoundFailure(message, statusCode: statusCode);
        }

        if (statusCode != null && statusCode >= 500) {
          return ServerFailure(message, statusCode: statusCode);
        }

        return UnknownFailure(message, statusCode: statusCode);
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return const NetworkFailure('No internet connection.');
        }
        return UnknownFailure(error.message ?? 'Unknown network error.');
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final dynamic detail = data['detail'];
      if (detail is Map<String, dynamic>) {
        final detailMessage = detail['message'];
        if (detailMessage is String && detailMessage.trim().isNotEmpty) {
          return detailMessage;
        }
      }

      final dynamic message =
          data['message'] ?? data['error'] ?? data['detail'] ?? data['msg'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }
    return null;
  }
}
