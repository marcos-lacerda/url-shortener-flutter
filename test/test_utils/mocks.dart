import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/core/services/link_opener.dart';
import 'package:url_shortener/features/link_shortener/domain/repositories/alias_repository.dart';
import 'package:url_shortener/features/link_shortener/domain/usecases/shorten_url.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_controller.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_state.dart';

class MockDio extends Mock implements Dio {}

class MockAliasRepository extends Mock implements IAliasRepository {}

class MockShortenUrl extends Mock implements ShortenUrl {}

class MockLinkOpener extends Mock implements UrlLauncherLinkOpener {}

class MockLinkShortenerController extends MockCubit<LinkShortenerState>
    implements LinkShortenerController {}
