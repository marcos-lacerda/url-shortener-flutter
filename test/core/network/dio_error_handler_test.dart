import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/network/dio_error_handler.dart';
import 'package:url_shortener/core/services/log_service.dart';

void main() {
  const handler = DioErrorHandler(LogService());
  const tag = 'test';

  Failure map(DioExceptionType type) {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/'),
      type: type,
    );
    return handler.handle<void>(exception, tag: tag).fold((l) => l, (_) =>
    throw StateError('expected failure'));
  }

  group('DioErrorHandler.handle', () {
    test('maps timeout types to TimeoutFailure', () {
      expect(map(DioExceptionType.connectionTimeout), isA<TimeoutFailure>());
      expect(map(DioExceptionType.receiveTimeout), isA<TimeoutFailure>());
      expect(map(DioExceptionType.sendTimeout), isA<TimeoutFailure>());
    });

    test('maps badCertificate/connectionError to NetworkFailure', () {
      expect(map(DioExceptionType.badCertificate), isA<NetworkFailure>());
      expect(map(DioExceptionType.connectionError), isA<NetworkFailure>());
    });

    test('maps cancel to ValidationFailure', () {
      final failure = map(DioExceptionType.cancel);
      expect(failure, isA<ValidationFailure>());
      expect(failure.code, 'errorCancelled');
    });

    test('maps badResponse to ServerFailure', () {
      final failure = map(DioExceptionType.badResponse);
      expect(failure, isA<ServerFailure>());
      expect(failure.code, 'errorServer');
    });

    test('maps unknown to UnknownFailure', () {
      final failure = map(DioExceptionType.unknown);
      expect(failure, isA<UnknownFailure>());
      expect(failure.code, 'errorUnexpected');
    });
  });
}
