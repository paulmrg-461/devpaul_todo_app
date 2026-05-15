import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    vertical: 14,
    horizontal: 16,
  );
  static const EdgeInsets dialogPadding = EdgeInsets.all(24);
}

class AppRadius {
  AppRadius._();

  static const double sm = 6;
  static const double md = 10;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 999;

  static BorderRadius get cardBorder => BorderRadius.circular(md);
  static BorderRadius get buttonBorder => BorderRadius.circular(md);
  static BorderRadius get inputBorder => BorderRadius.circular(md);
  static BorderRadius get dialogBorder => BorderRadius.circular(lg);
  static BorderRadius get chipBorder => BorderRadius.circular(full);
  static BorderRadius get avatarBorder => BorderRadius.circular(full);
}

class AppDuration {
  AppDuration._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration pageTransition = Duration(milliseconds: 350);
  static const Duration staggerDelay = Duration(milliseconds: 60);
}

class AppShadows {
  AppShadows._();

  static List<BoxShadow> card(Brightness brightness) => [
        BoxShadow(
          color: brightness == Brightness.light
              ? const Color(0x0A000000)
              : const Color(0x1A000000),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: brightness == Brightness.light
              ? const Color(0x05000000)
              : const Color(0x0D000000),
          blurRadius: 2,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> elevated(Brightness brightness) => [
        BoxShadow(
          color: brightness == Brightness.light
              ? const Color(0x12000000)
              : const Color(0x24000000),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: brightness == Brightness.light
              ? const Color(0x08000000)
              : const Color(0x10000000),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];
}

class AppFontScale {
  AppFontScale._();

  static const double hero = 40;
  static const double h1 = 32;
  static const double h2 = 28;
  static const double h3 = 24;
  static const double h4 = 20;
  static const double body = 16;
  static const double label = 14;
  static const double caption = 12;
  static const double tiny = 11;

  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.7;
}

class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double wide = 1600;
}

class AppMaxWidth {
  AppMaxWidth._();

  static const double form = 480;
  static const double card = 720;
  static const double content = 960;
  static const double page = 1200;
}
