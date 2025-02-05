import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static bool isDarkMode = false;
  // static const Color primaryColor = Color(0xffa6ce39);
  static const Color primaryColor = Colors.lightGreen;
  static final TextStyle defaultFontStyle = GoogleFonts.manrope();

  static final TextTheme textTheme = TextTheme(
    headlineLarge: defaultFontStyle,
    headlineMedium: defaultFontStyle,
    headlineSmall: defaultFontStyle,
    bodyLarge: defaultFontStyle,
    bodyMedium: defaultFontStyle,
    bodySmall: defaultFontStyle,
    displayLarge: defaultFontStyle,
    displayMedium: defaultFontStyle,
    displaySmall: defaultFontStyle,
    titleLarge: defaultFontStyle,
    titleMedium: defaultFontStyle,
    titleSmall: defaultFontStyle,
    labelLarge: defaultFontStyle,
    labelMedium: defaultFontStyle,
    labelSmall: defaultFontStyle,
  );

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    colorScheme: ColorScheme.fromSeed(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      seedColor: primaryColor,
      // dynamicSchemeVariant: DynamicSchemeVariant.fidelity
    ),
  );
}
