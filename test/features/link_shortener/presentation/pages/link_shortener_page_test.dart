import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:url_shortener/app/di/injection.dart';
import 'package:url_shortener/features/link_shortener/domain/entities/short_link.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_controller.dart';
import 'package:url_shortener/features/link_shortener/presentation/controllers/link_shortener_state.dart';
import 'package:url_shortener/features/link_shortener/presentation/pages/link_shortener_page.dart';
import 'package:url_shortener/l10n/app_localizations.dart';

import '../../../../test_utils/mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const LinkShortenerIdle());
  });

  setUp(() async {
    await getIt.reset();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    required LinkShortenerController controller,
  }) async {
    when(() => controller.close()).thenAnswer((_) async {});

    getIt.registerFactory<LinkShortenerController>(() => controller);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LinkShortenerPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows empty state when idle and list is empty', (tester) async {
    final controller = MockLinkShortenerController();
    when(() => controller.state).thenReturn(const LinkShortenerIdle());
    whenListen(controller, const Stream<LinkShortenerState>.empty(),
        initialState: const LinkShortenerIdle());

    await pumpPage(tester, controller: controller);

    expect(find.text('No links yet'), findsOneWidget);
    expect(
      find.text("You haven't shortened any links yet. Start now!"),
      findsOneWidget,
    );
  });

  testWidgets('shows progress indicator while loading', (tester) async {
    final controller = MockLinkShortenerController();
    when(() => controller.state).thenReturn(
      const LinkShortenerLoading(items: []),
    );
    whenListen(
      controller,
      const Stream<LinkShortenerState>.empty(),
      initialState: const LinkShortenerLoading(items: []),
    );

    await pumpPage(tester, controller: controller);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('renders list tiles when success has items', (tester) async {
    final controller = MockLinkShortenerController();
    final link = ShortLink(
      original: Uri.parse('https://example.com'),
      short: Uri.parse('https://short/abc'),
    );
    final successState = LinkShortenerSuccess(items: [link]);

    when(() => controller.state).thenReturn(successState);
    whenListen(
      controller,
      const Stream<LinkShortenerState>.empty(),
      initialState: successState,
    );

    await pumpPage(tester, controller: controller);

    expect(find.text('https://short/abc'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('shows error message and calls clearError on close',
          (tester) async {
    final controller = MockLinkShortenerController();
    const errorState = LinkShortenerError(
      errorCode: 'errorNetwork',
      items: [],
    );

    when(() => controller.state).thenReturn(errorState);
    when(controller.clearError).thenAnswer((_) {});
    whenListen(
      controller,
      const Stream<LinkShortenerState>.empty(),
      initialState: errorState,
    );

    await pumpPage(tester, controller: controller);

    expect(
      find.text(
        'No internet connection. Please check your network and try again.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('error_close_button')));
    await tester.pump();

    verify(controller.clearError).called(1);
  });
}
