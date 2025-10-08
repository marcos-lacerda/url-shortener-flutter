import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:url_shortener/core/constants/api_endpoints.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/network/dio_error_handler.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/core/result/either_extensions.dart';
import 'package:url_shortener/core/services/log_service.dart';
import 'package:url_shortener/features/link_shortener/data/dtos/short_link_dto.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/repositories/alias_repository.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';

@LazySingleton(as: IAliasRepository)
class AliasRepositoryImpl implements IAliasRepository {
  AliasRepositoryImpl({required Dio dio, required LogService log})
    : _dio = dio,
      _log = log,
      _errorHandler = DioErrorHandler(log);
  final Dio _dio;
  final LogService _log;
  final DioErrorHandler _errorHandler;

  static const _defaultHeaders = {
    'Content-Type': 'application/json',
    'x-origin': 'br.com.nu.url.shortener',
  };

  Options get _options => Options(headers: _defaultHeaders);

  @override
  Future<Either<Failure, ShortLink>> shortenURL({
    required UrlToShorten url,
  }) async {
    final endpoint = ApiEndpoints.full(ApiEndpoints.aliasCreate);

    final body = {'url': url.value.toString()};

    _log..info('POST $endpoint', tag: 'AliasRepo')
    ..info('Body: $body', tag: 'AliasRepo');

    try {
      final response = await _dio.post<Map<String, dynamic>>(endpoint,
          data: body, options: _options);
      _log.success('Response: ${response.statusCode}', tag: 'AliasRepo');

      if (response.data is! Map<String, dynamic>) {
        return left(const ServerFailure('errorMalformedResponse'));
      }

      final dto = ShortLinkDto.fromJson(response.data!);
      return right(dto.toDomain());
    } on DioException catch (e) {
      return _errorHandler.handle<ShortLink>(e, tag: 'AliasRepo');
    } on Object catch (e, s) {
      _log.error('Unexpected error', tag: 'AliasRepo', error: e, stackTrace: s);
      return left(const UnknownFailure('errorUnexpectedWithDetail'));
    }
  }

  @override
  Future<Either<Failure, Uri>> getAlias({required Alias alias}) async {
    final endpoint = ApiEndpoints.full(ApiEndpoints.aliasDetails(alias.value));

    _log.info('GET $endpoint', tag: 'AliasRepo');

    try {
      final response = await _dio.get<Map<String, dynamic>>(endpoint,
          options: _options);
      _log.success('Response: ${response.statusCode}', tag: 'AliasRepo');

      if (response.data is! Map<String, dynamic>) {
        return left(const ServerFailure('errorMalformedResponse'));
      }

      final url = response.data!['url'] as String?;

      if (url == null || url.isEmpty) {
        return left(const ServerFailure('errorMissingFieldUrl'));
      }

      return right(Uri.parse(url));
    } on DioException catch (e) {
      return _errorHandler.handle<Uri>(e, tag: 'AliasRepo');
    } on Object catch (e, s) {
      _log.error('Unexpected error', tag: 'AliasRepo', error: e, stackTrace: s);
      return left(const UnknownFailure('errorUnexpectedWithDetail'));
    }
  }
}
