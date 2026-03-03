abstract class ApiFailure {
  final String message;
  final int? statusCode;

  const ApiFailure(this.message, {this.statusCode});
}

class NetworkFailure extends ApiFailure {
  const NetworkFailure(String message) : super(message);
}

class UnauthorizedFailure extends ApiFailure {
  const UnauthorizedFailure(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class NotFoundFailure extends ApiFailure {
  const NotFoundFailure(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class ServerFailure extends ApiFailure {
  const ServerFailure(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}

class ParsingFailure extends ApiFailure {
  const ParsingFailure(String message) : super(message);
}

class UnknownFailure extends ApiFailure {
  const UnknownFailure(String message, {int? statusCode})
      : super(message, statusCode: statusCode);
}
