import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  /// Base text theme
  static TextTheme get textTheme => GoogleFonts.nunitoTextTheme().copyWith(
    displayLarge: _displayLarge,
    displayMedium: _displayMedium,
    displaySmall: _displaySmall,
    headlineMedium: _headlineMedium,
    titleLarge: _titleLarge,
    bodyLarge: _bodyLarge,
    bodyMedium: _bodyMedium,
    bodySmall: _bodySmall,
    labelLarge: _labelLarge,
    labelSmall: _labelSmall,
  );

  static final TextStyle _displayLarge = GoogleFonts.nunito(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
  );

  static final TextStyle _displayMedium = GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final TextStyle _displaySmall = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  // Headline → títulos de seções e cards
  static final TextStyle _headlineMedium = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Title → títulos de botões e headers
  static final TextStyle _titleLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  // Body → textos principais e secundários
  static final TextStyle _bodyLarge = GoogleFonts.nunito(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static final TextStyle _bodyMedium = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final TextStyle _bodySmall = GoogleFonts.nunito(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Labels → textos auxiliares, botões pequenos e campos
  static final TextStyle _labelLarge = GoogleFonts.nunito(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static final TextStyle _labelSmall = GoogleFonts.nunito(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  /// Helper para aplicar facilmente no ThemeData
  static ThemeData applyToTheme(ThemeData base) {
    return base.copyWith(
      textTheme: textTheme,
    );
  }
}
