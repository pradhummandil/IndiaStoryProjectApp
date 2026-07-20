/// Typed application exceptions mapped from HTTP / network errors.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseData;

  const ApiException({
    required this.message,
    this.statusCode,
    this.responseData,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class BadRequestException extends ApiException {
  const BadRequestException({
    super.message = 'Bad request',
    super.statusCode = 400,
    super.responseData,
  });
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode = 401,
    super.responseData,
  });
}

class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'Forbidden',
    super.statusCode = 403,
    super.responseData,
  });
}

class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.responseData,
  });
}

class ServerErrorException extends ApiException {
  const ServerErrorException({
    super.message = 'Internal server error',
    super.statusCode = 500,
    super.responseData,
  });
}

class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.statusCode,
  });
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
  });
}

/// Maps an HTTP status code to the appropriate [ApiException].
ApiException httpErrorFromStatusCode(int code, [dynamic data]) {
  switch (code) {
    case 400:
      return BadRequestException(responseData: data);
    case 401:
      return UnauthorizedException(responseData: data);
    case 403:
      return ForbiddenException(responseData: data);
    case 404:
      return NotFoundException(responseData: data);
    case 500:
      return ServerErrorException(responseData: data);
    default:
      return ApiException(
        message: 'Unexpected error ($code)',
        statusCode: code,
        responseData: data,
      );
  }
}
