import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_tokens.dart';

class AppColors {
  AppColors._();

  // Primary palette — refined indigo
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);

  // Accent — warm amber
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFCD34D);

  // Semantic status colors
  static const Color statusPending = Color(0xFFF59E0B);
  static const Color statusInProgress = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF10B981);

  // Semantic priority colors
  static const Color priorityLow = Color(0xFF6B7280);
  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityHigh = Color(0xFFEF4444);

  // Task type colors
  static const Color typeWork = Color(0xFF3B82F6);
  static const Color typePersonal = Color(0xFF8B5CF6);
  static const Color typeAcademic = Color(0xFF10B981);
  static const Color typeLeisure = Color(0xFFF97316);

  // Light surface scale
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceContainerLight = Color(0xFFF4F4F5);
  static const Color surfaceContainerHighestLight = Color(0xFFE8E8EC);

  // Dark surface scale
  static const Color surfaceDark = Color(0xFF0F0F12);
  static const Color surfaceContainerDark = Color(0xFF1A1A1F);
  static const Color surfaceContainerHighestDark = Color(0xFF27272D);

  // Error
  static const Color error = Color(0xFFE11D48);

  // On colors
  static const Color onPrimary = Colors.white;
  static const Color onDark = Color(0xFFF8F8FB);
  static const Color onLight = Color(0xFF18181B);
}

class CustomTheme {
  CustomTheme._();

  static final TextStyle _baseStyle = GoogleFonts.manrope();

  static TextTheme _buildTextTheme(Color onSurface) {
    final base = _baseStyle.copyWith(color: onSurface);
    return TextTheme(
      headlineLarge: base.copyWith(
        fontSize: AppFontScale.h1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: AppFontScale.lineHeightTight,
      ),
      headlineMedium: base.copyWith(
        fontSize: AppFontScale.h2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.25,
        height: AppFontScale.lineHeightTight,
      ),
      headlineSmall: base.copyWith(
        fontSize: AppFontScale.h3,
        fontWeight: FontWeight.w600,
        height: AppFontScale.lineHeightTight,
      ),
      titleLarge: base.copyWith(
        fontSize: AppFontScale.h4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: AppFontScale.lineHeightNormal,
      ),
      titleMedium: base.copyWith(
        fontSize: AppFontScale.body,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: AppFontScale.lineHeightNormal,
      ),
      titleSmall: base.copyWith(
        fontSize: AppFontScale.label,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: AppFontScale.lineHeightNormal,
      ),
      bodyLarge: base.copyWith(
        fontSize: AppFontScale.body,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: AppFontScale.lineHeightRelaxed,
      ),
      bodyMedium: base.copyWith(
        fontSize: AppFontScale.label,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: AppFontScale.lineHeightRelaxed,
      ),
      bodySmall: base.copyWith(
        fontSize: AppFontScale.caption,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: AppFontScale.lineHeightNormal,
      ),
      labelLarge: base.copyWith(
        fontSize: AppFontScale.label,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: AppFontScale.lineHeightNormal,
      ),
      labelMedium: base.copyWith(
        fontSize: AppFontScale.caption,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: AppFontScale.lineHeightNormal,
      ),
      labelSmall: base.copyWith(
        fontSize: AppFontScale.tiny,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: AppFontScale.lineHeightNormal,
      ),
    );
  }

  static ColorScheme _buildColorScheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return ColorScheme(
      brightness: brightness,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: isDark ? AppColors.primaryDark : AppColors.primaryLight,
      onPrimaryContainer: isDark ? AppColors.onDark : AppColors.onLight,
      secondary: AppColors.accent,
      onSecondary: Colors.black,
      secondaryContainer:
          isDark ? const Color(0xFF4A3000) : const Color(0xFFFFF7ED),
      onSecondaryContainer: isDark ? AppColors.onDark : AppColors.onLight,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer:
          isDark ? const Color(0xFF4C0519) : const Color(0xFFFFF1F2),
      onErrorContainer: AppColors.error,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      onSurface: isDark ? AppColors.onDark : AppColors.onLight,
      surfaceContainerHighest: isDark
          ? AppColors.surfaceContainerHighestDark
          : AppColors.surfaceContainerHighestLight,
      onSurfaceVariant: isDark
          ? const Color(0xFFA1A1AA)
          : const Color(0xFF71717A),
      outline: isDark ? const Color(0xFF3F3F46) : const Color(0xFFD4D4D8),
      outlineVariant:
          isDark ? const Color(0xFF27272A) : const Color(0xFFE8E8EC),
      shadow: Colors.black26,
      scrim: Colors.black38,
      inverseSurface: isDark ? AppColors.surfaceLight : AppColors.surfaceDark,
      onInverseSurface: isDark ? AppColors.onLight : AppColors.onDark,
      inversePrimary: isDark ? AppColors.primaryDark : AppColors.primaryLight,
    );
  }

  static ThemeData getThemeData(bool isDarkMode) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    final colorScheme = _buildColorScheme(brightness);
    final onSurface = colorScheme.onSurface;
    final textTheme = _buildTextTheme(onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: textTheme.titleLarge,
        surfaceTintColor: Colors.transparent,
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardBorder,
        ),
        color: isDarkMode
            ? AppColors.surfaceContainerDark
            : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkMode
            ? AppColors.surfaceContainerDark
            : AppColors.surfaceContainerLight,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(
            color: colorScheme.outline.withAlpha(128),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        labelStyle: textTheme.bodySmall,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withAlpha(90),
        ),
      ),

      // Filled Button
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonBorder,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md + 2,
          ),
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(0, 48),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonBorder,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md + 2,
          ),
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: colorScheme.outline),
          minimumSize: const Size(0, 44),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge,
          foregroundColor: colorScheme.primary,
        ),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: WidgetStatePropertyAll(
          IconThemeData(color: colorScheme.onSurfaceVariant, size: 22),
        ),
      ),

      // Navigation Drawer
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle: textTheme.titleSmall,
        dividerColor: Colors.transparent,
      ),

      // Chips
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.chipBorder,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        labelStyle: textTheme.labelSmall,
        side: BorderSide.none,
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.dialogBorder,
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonBorder,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
