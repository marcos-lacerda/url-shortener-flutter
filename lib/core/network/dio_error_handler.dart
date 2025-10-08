import 'package:dio/dio.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/core/result/either_extensions.dart';
import 'package:url_shortener/core/services/log_service.dart';

/// Classe responsável por mapear e tratar erros do Dio.
/// Transforma [DioException] em instâncias de [Failure],
class DioErrorHandler {
  const DioErrorHandler(this._log);

  final LogService _log;

  Either<Failure, T> handle<T>(DioException e, {String? tag}) {
    _log.error(
      'DioException: ${e.message}',
      tag: tag,
      error: e,
      stackTrace: e.stackTrace,
    );

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return left(const TimeoutFailure('errorTimeout'));

      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return left(const NetworkFailure('errorNetwork'));

      case DioExceptionType.cancel:
        return left(const ValidationFailure('errorCancelled'));

      case DioExceptionType.badResponse:
        return left(const ServerFailure('errorServer'));

      case DioExceptionType.unknown:
        return left(const UnknownFailure());
    }
  }
}
