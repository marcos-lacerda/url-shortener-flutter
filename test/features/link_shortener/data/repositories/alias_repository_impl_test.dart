import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/services/log_service.dart';
import 'package:url_shortener/features/link_shortener/data/repositories/alias_repository_impl.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';

import '../../../../test_utils/mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  group('AliasRepositoryImpl', () {
    late MockDio dio;
    late AliasRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = AliasRepositoryImpl(dio: dio, log: const LogService());
    });

    group('shortenURL', () {
      test('returns ShortLink on success', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 201,
            data: {
              'alias': '123',
              '_links': {
                'self': 'https://example.com/article',
                'short': 'https://short/123',
              },
            },
            requestOptions: RequestOptions(path: '/api/alias'),
          ),
        );

        final url = UrlToShorten.tryParse('https://example.com/article').rightOrNull!;
        final result = await repository.shortenURL(url: url);

        expect(result.isRight, isTrue);
        expect(result.rightOrNull!.alias?.value, '123');
        verify(
          () => dio.post<Map<String, dynamic>>(
            'https://url-shortener-server.onrender.com/api/alias',
            data: {'url': 'https://example.com/article'},
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('maps DioException using error handler', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/alias'),
            type: DioExceptionType.connectionError,
          ),
        );

        final url = UrlToShorten.tryParse('https://example.com').rightOrNull!;
        final result = await repository.shortenURL(url: url);

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<NetworkFailure>());
      });
    });

    group('getAlias', () {
      test('returns Uri on success', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: {'url': 'https://example.com'},
            requestOptions: RequestOptions(path: '/api/alias/123'),
          ),
        );

        final result = await repository.getAlias(alias: Alias.tryParse('123')!);

        expect(result.isRight, isTrue);
        expect(result.rightOrNull.toString(), 'https://example.com');
        verify(
          () => dio.get<Map<String, dynamic>>(
            'https://url-shortener-server.onrender.com/api/alias/123',
            options: any(named: 'options'),
          ),
        ).called(1);
      });

      test('returns ServerFailure when url field is missing', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            any(),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            statusCode: 200,
            data: {},
            requestOptions: RequestOptions(path: '/api/alias/123'),
          ),
        );

        final result = await repository.getAlias(alias: Alias.tryParse('123')!);

        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<ServerFailure>());
      });
    });
  });
}
