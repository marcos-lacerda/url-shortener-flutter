import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/errors/failure.dart';
import 'package:url_shortener/core/result/either.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/alias.dart';
import 'package:url_shortener/features/link_shortener/domain/value_objects/url_to_shorten.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_controller.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_state.dart';

import '../../../../test_utils/mocks.dart';

void main() {
  final fallbackUrlToShorten = UrlToShorten
      .tryParse('https://fallback.dev')
      .fold((_) => throw StateError('fallback UrlToShorten inválido'),
          (v) => v);

  final fallbackShortLink = ShortLink(
    original: Uri.parse('https://fallback.dev'),
    short: Uri.parse('https://short/fallback'),
  );

  final fallbackAlias = Alias.tryParse('0')!;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://fallback.dev'));
    registerFallbackValue(fallbackUrlToShorten);
    registerFallbackValue(fallbackShortLink);
    registerFallbackValue(fallbackAlias);
  });

  group('LinkShortenerController', () {
    late MockShortenUrl shortenUrl;
    late MockGetAlias getAlias;
    late MockLinkOpener linkOpener;

    LinkShortenerController buildController() =>
        LinkShortenerController(shortenUrl, getAlias, linkOpener);

    setUp(() {
      shortenUrl = MockShortenUrl();
      getAlias = MockGetAlias();
      linkOpener = MockLinkOpener();
    });

    blocTest<LinkShortenerController, LinkShortenerState>(
      'does nothing when input is blank',
      build: buildController,
      act: (bloc) => bloc.shorten('   '),
      expect: () => <LinkShortenerState>[],
      verify: (_) {
        verifyNever(() => shortenUrl(any<UrlToShorten>()));
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'emits Loading then Success on shorten success',
      build: buildController,
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
            .having((s) => s.items.first.original.toString(), 'first',
                'https://example.com'),
      ],
      verify: (_) {
        verify(() => shortenUrl(any<UrlToShorten>())).called(1);
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'emits Loading then Error on shorten failure '
      '(usecase fails after valid URL)',
      build: buildController,
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
        verify(() => shortenUrl(any<UrlToShorten>())).called(1);
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'promotes duplicate link to top without calling shorten usecase',
      build: buildController,
      seed: () => LinkShortenerSuccess(
        items: [
          ShortLink(
            original: Uri.parse('https://dart.dev'),
            short: Uri.parse('https://short/dart'),
          ),
          ShortLink(
            original: Uri.parse('https://example.com'),
            short: Uri.parse('https://short/abc'),
          ),
        ],
      ),
      act: (cubit) => cubit.shorten('https://example.com'),
      expect: () => [
        isA<LinkShortenerSuccess>()
            .having((s) => s.items.first.original.toString(), 'first',
                'https://example.com')
            .having((s) => s.items.length, 'len', 2),
      ],
      verify: (_) {
        verifyNever(() => shortenUrl(any<UrlToShorten>()));
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'detects duplicate when input lacks scheme (normalized comparison)',
      build: buildController,
      seed: () => LinkShortenerSuccess(
        items: [
          ShortLink(
            original: Uri.parse('https://dart.dev'),
            short: Uri.parse('https://short/dart'),
          ),
          ShortLink(
            original: Uri.parse('https://www.globo.com'),
            short: Uri.parse('https://short/globo'),
          ),
        ],
      ),
      act: (cubit) => cubit.shorten('www.globo.com'),
      expect: () => [
        isA<LinkShortenerSuccess>()
            .having((s) => s.items.first.original.toString(), 'first',
                'https://www.globo.com')
            .having((s) => s.items.length, 'len', 2),
      ],
      verify: (_) {
        verifyNever(() => shortenUrl(any<UrlToShorten>()));
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'open resolves URL via getAlias when alias is present',
      build: buildController,
      setUp: () {
        when(() => getAlias(any<Alias>())).thenAnswer(
          (_) async => Right(Uri.parse('https://resolved.example')),
        );
        when(() => linkOpener.open(any<Uri>())).thenAnswer((_) async => true);
      },
      act: (bloc) => bloc.open(
        ShortLink(
          alias: Alias.tryParse('123'),
          original: Uri.parse('https://example.com'),
          short: Uri.parse('https://short/abc'),
        ),
      ),
      expect: () => <LinkShortenerState>[],
      verify: (_) {
        verify(() => getAlias(any<Alias>())).called(1);
        verify(() => linkOpener.open(Uri.parse('https://resolved.example')))
            .called(1);
        verifyNever(() => linkOpener.open(Uri.parse('https://example.com')));
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'open falls back to original when getAlias fails',
      build: buildController,
      setUp: () {
        when(() => getAlias(any<Alias>())).thenAnswer(
          (_) async => const Left<Failure, Uri>(NetworkFailure('errorNetwork')),
        );
        when(() => linkOpener.open(any<Uri>())).thenAnswer((_) async => true);
      },
      act: (bloc) => bloc.open(
        ShortLink(
          alias: Alias.tryParse('123'),
          original: Uri.parse('https://example.com'),
          short: Uri.parse('https://short/abc'),
        ),
      ),
      expect: () => <LinkShortenerState>[],
      verify: (_) {
        verify(() => getAlias(any<Alias>())).called(1);
        verify(() => linkOpener.open(Uri.parse('https://example.com')))
            .called(1);
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'open opens original directly when alias is null',
      build: buildController,
      setUp: () {
        when(() => linkOpener.open(any<Uri>())).thenAnswer((_) async => true);
      },
      act: (bloc) => bloc.open(
        ShortLink(
          original: Uri.parse('https://example.com'),
          short: Uri.parse('https://short/abc'),
        ),
      ),
      expect: () => <LinkShortenerState>[],
      verify: (_) {
        verifyNever(() => getAlias(any<Alias>()));
        verify(() => linkOpener.open(Uri.parse('https://example.com')))
            .called(1);
      },
    );

    blocTest<LinkShortenerController, LinkShortenerState>(
      'open emits error when launch fails',
      build: buildController,
      setUp: () {
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
        verify(() => linkOpener.open(Uri.parse('https://example.com')))
            .called(1);
      },
    );
  });
}
