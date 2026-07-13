import 'package:flutter/material.dart';

abstract class AppTheme {
  // Poppins has weights: 400 (Regular), 500 (Medium), 600 (SemiBold)
  // Lato has weights: 400 (Regular), 700 (Bold)
  // Since Lato has no 500/600, we use 400 for medium and 700 for bold/semibold

  static const String _displayFont = 'Poppins';
  static const String _bodyFont = 'Lato';

  static final lightTheme = ThemeData(
    textTheme: baseTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.light,
    ),
  );
  static final darkTheme = ThemeData(
    textTheme: baseTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.dark,
    ),
  );

  static final TextTheme baseTextTheme = TextTheme(
    // Display Styles - für Hero-Texte
    displayLarge: TextStyle(
      fontFamily: _displayFont,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamily: _displayFont,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontFamily: _displayFont,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),

    // Headline Styles - für Überschriften
    headlineLarge: TextStyle(
      fontFamily: _displayFont,
      fontSize: 32,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: _displayFont,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: _displayFont,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),

    // Title Styles - für Komponenten-Titel
    titleLarge: TextStyle(fontFamily: _bodyFont, fontSize: 22, fontWeight: FontWeight.w700),
    titleMedium: TextStyle(fontFamily: _bodyFont, fontSize: 18, fontWeight: FontWeight.w400),
    titleSmall: TextStyle(fontFamily: _bodyFont, fontSize: 16, fontWeight: FontWeight.w400),

    // Body Styles - für Fließtext
    bodyLarge: TextStyle(fontFamily: _bodyFont, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontFamily: _bodyFont, fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontFamily: _bodyFont, fontSize: 12, fontWeight: FontWeight.w400),

    // Label Styles - für Beschriftungen
    labelLarge: TextStyle(fontFamily: _bodyFont, fontSize: 14, fontWeight: FontWeight.w400),
    labelMedium: TextStyle(fontFamily: _bodyFont, fontSize: 12, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontFamily: _bodyFont, fontSize: 11, fontWeight: FontWeight.w400),
  );

  static final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
    ThemeMode.system,
  );
}