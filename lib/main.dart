import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_shortener/app/di/injection.dart';
import 'package:url_shortener/core/theme/app_colors.dart';
import 'package:url_shortener/core/theme/app_fonts.dart';
import 'package:url_shortener/features/link_shortener/presentation/pages/link_shortener_page.dart';
import 'package:url_shortener/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  // 🔒 trava a orientação em portrait (vertical)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const LinkShortenerApp());
}

class LinkShortenerApp extends StatelessWidget {
  const LinkShortenerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('pt', 'BR'),
      ],
      theme: AppColors.theme(textTheme: AppFonts.textTheme),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
          default:
            return MaterialPageRoute<void>(
              builder: (_) => const LinkShortenerPage(),
              settings: const RouteSettings(name: '/'),
            );
        }
      },
    );
  }
}
