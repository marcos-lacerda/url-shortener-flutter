import 'package:flutter/material.dart';

/// Paleta inspirada no visual do Nubank (tons de roxo + neutros).
/// Use `scheme()` para obter um ColorScheme coerente (Material 3).
class AppColors {
  // ====== Primitives ======
  // Primários (Roxo)
  static const Color primary = Color(0xFF8A05BE);
  static const Color primaryDark = Color(0xFF4E007B);
  static const Color primaryLight = Color(0xFFEED9F6);

  // Neutros
  static const Color black = Color(0xFF111111);
  static const Color gray900 = Color(0xFF222222);
  static const Color gray700 = Color(0xFF6C6C6C);
  static const Color gray500 = Color(0xFF9B9B9B);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color white = Color(0xFFFFFFFF);

  // Feedback
  static const Color success = Color(0xFF1DB954);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFEA4335);

  // ====== Semantic shortcuts ======
  static const Color brand = primary;
  static const Color onBrand = white;

  static const Color backgroundLight = white;
  static const Color surfaceLight = Color(0xFFF9F9FB);

  static const Color backgroundDark = Color(0xFF0F0F12);
  static const Color surfaceDark = Color(0xFF17171C);

  // ====== ColorScheme builder ======
  static ColorScheme scheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ColorScheme(
      brightness: brightness,
      primary: brand,
      onPrimary: onBrand,
      primaryContainer: isDark ? primaryDark : primaryLight,
      onPrimaryContainer: isDark ? white : primaryDark,

      secondary: isDark ? gray500 : gray700,
      onSecondary: isDark ? black : white,
      secondaryContainer: isDark ? gray700 : gray200,
      onSecondaryContainer: isDark ? white : gray900,

      tertiary: isDark ? primaryLight : primaryDark,
      onTertiary: isDark ? black : white,
      tertiaryContainer: isDark ? primaryDark : primaryLight,
      onTertiaryContainer: isDark ? white : primaryDark,

      error: error,
      onError: white,
      errorContainer: isDark
          ? const Color(0xFF7C1E17)
          : const Color(0xFFFFE3E0),
      onErrorContainer: isDark ? white : const Color(0xFF5D1A16),

      surface: isDark ? surfaceDark : surfaceLight,
      onSurface: isDark ? white : gray900,

      surfaceContainerHighest: isDark
          ? const Color(0xFF1F1F25)
          : const Color(0xFFEDEAF2),
      onSurfaceVariant: isDark ? gray200 : gray700,

      outline: isDark ? gray500 : gray700,
      outlineVariant: isDark
          ? const Color(0xFF2C2C34)
          : const Color(0xFFE2DDEB),

      shadow: Colors.black.withValues(alpha: isDark ? 0.65 : 0.15),
      scrim: Colors.black.withValues(alpha: 0.5),

      inverseSurface: isDark ? backgroundLight : backgroundDark,
      onInverseSurface: isDark ? gray900 : white,
      inversePrimary: isDark ? primaryLight : primaryDark,
    );
  }

  static ThemeData theme({
    Brightness brightness = Brightness.light,
    TextTheme? textTheme,
  }) {
    final cs = scheme(brightness);
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      brightness: brightness,
      scaffoldBackgroundColor: cs.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: textTheme?.bodyMedium?.copyWith(
          color: cs.onInverseSurface,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerColor: cs.outlineVariant,
    );
  }
}
