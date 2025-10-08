import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_controller.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_state.dart';

import '../../../../test_utils/mocks.dart';

void main() {
  final fallbackUrlToShorten = UrlToShorten
      .tryParse('https://fallback.example')
      .fold((_) => throw StateError('fallback UrlToShorten inválido'),
          (v) => v);

  final fallbackShortLink = ShortLink(
    original: Uri.parse('https://fallback.dev'),
    short: Uri.parse('https://short/fallback'),
  );

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.example'));
    registerFallbackValue(fallbackUrlToShorten);
    registerFallbackValue(fallbackShortLink);
  });

  group('LinkShortenerController', () {
    late MockShortenUrl shortenUrl;
    late MockLinkOpener linkOpener;

    setUp(() {
      shortenUrl = MockShortenUrl();
      linkOpener = MockLinkOpener();
    });

    blocTest<LinkShortenerController, LinkShortenerState>(
      'does nothing when input is blank',
      build: () => LinkShortenerController(shortenUrl, linkOpener),
      act: (bloc) => bloc.shorten('   '),
      expect: () => <LinkShortenerState>[],
      verify: (_) {
        verifyNever(() => shortenUrl(any<UrlToShorten>()));
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'emits Loading then Success on shorten success',
      build: () => LinkShortenerController(shortenUrl, linkOpener),
      setUp: () {
        when(() => shortenUrl(any<UrlToShorten>())).thenAnswer(
              (_) async => Right(
            ShortLink(
              original: Uri.parse('https://example.com'),
              short: Uri.parse('https://short/abc'),
            ),
          ),
        );
      },
      act: (bloc) => bloc.shorten('https://example.com'),
      expect: () => [
        isA<LinkShortenerLoading>(),
        isA<LinkShortenerSuccess>()
            .having((s) => s.items.length, 'len', 1)
            .having((s) => s.items.first.original.toString(), 'first', 'https://example.com'),
      ],
      verify: (_) {
        verify(() => shortenUrl(any<UrlToShorten>())).called(1);
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'emits Loading then Error on shorten failure '
          '(usecase fails after valid URL)',
      build: () => LinkShortenerController(shortenUrl, linkOpener),
      setUp: () {
        when(() => shortenUrl(any<UrlToShorten>())).thenAnswer(
              (_) async => const Left<Failure, ShortLink>(
            ValidationFailure('errorInvalidUrlFormat'),
          ),
        );
      },
      act: (bloc) => bloc.shorten('https://example.com'),
      expect: () => [
        isA<LinkShortenerLoading>(),
        isA<LinkShortenerError>()
            .having((s) => s.errorCode, 'errorCode', 'errorInvalidUrlFormat'),
      ],
      verify: (_) {
        // garante que o usecase foi realmente chamado
        verify(() => shortenUrl(any<UrlToShorten>())).called(1);
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'promotes duplicate link to top without calling shorten usecase',
      build: () => LinkShortenerController(shortenUrl, linkOpener),
      seed: () => LinkShortenerSuccess(
        items: [
          ShortLink(
            original: Uri.parse('https://dart.dev'),
            short: Uri.parse('https://short/dart'),
          ),
          // Duplicado NÃO está no topo
          ShortLink(
            original: Uri.parse('https://example.com'),
            short: Uri.parse('https://short/abc'),
          ),
        ],
      ),
      act: (cubit) => cubit.shorten('https://example.com'),
      expect: () => [
        isA<LinkShortenerSuccess>()
            .having((s) => s.items.first.original.toString(), 'first', 'https://example.com')
            .having((s) => s.items.length, 'len', 2),
      ],
      verify: (_) {
        verifyNever(() => shortenUrl(any<UrlToShorten>()));
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'open tries short, then original, and emits error when both fail',
      build: () => LinkShortenerController(shortenUrl, linkOpener),
      setUp: () {
        // falha para short e para original
        when(() => linkOpener.open(any<Uri>())).thenAnswer((_) async => false);
      },
      act: (bloc) => bloc.open(
        ShortLink(
          original: Uri.parse('https://example.com'),
          short: Uri.parse('https://short/abc'),
        ),
      ),
      expect: () => [
        isA<LinkShortenerError>()
            .having((s) => s.errorCode, 'errorCode', 'errorOpenUrlFailed'),
      ],
      verify: (_) {
        verify(() => linkOpener.open(Uri.parse('https://short/abc'))).called(1);
        verify(() => linkOpener.open(Uri.parse('https://example.com'))).called(1);
      },
    );
  });
}
