import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/usecases/shorten_url.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';

import '../../../../test_utils/mocks.dart';

void main() {
  group('ShortenUrl', () {
    late MockAliasRepository repository;
    late ShortenUrl usecase;

    setUp(() {
      repository = MockAliasRepository();
      usecase = ShortenUrl(repository);
    });

    test('delegates to repository', () async {
      final url = UrlToShorten.tryParse('https://example.com').rightOrNull!;
      final shortLink = ShortLink(
        original: Uri.parse('https://example.com'),
        short: Uri.parse('https://short/abc'),
      );

      when(() => repository.shortenURL(url: url))
          .thenAnswer((_) async =>  Right<Failure, ShortLink>(shortLink));

      final result = await usecase(url);

      expect(result.isRight, isTrue);
      expect(result.rightOrNull, shortLink);
      verify(() => repository.shortenURL(url: url)).called(1);
    });
  });
}
