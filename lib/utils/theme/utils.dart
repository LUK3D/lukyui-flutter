import 'package:flutter/material.dart';

class LukyColorScheme {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color secondaryVariant;
  final Color background;
  final Color surface;
  final Color success;
  final Color warning;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;
  final Color light;
  final Color dark;
  final Color grey;
  final Color defaultBackground;
  final Color defaultForeground;
  final Color dividerColor;
  final Color canvas;
  final Color onSuccess;
  final Color onWarning;
  final Color onErrorLight;

  LukyColorScheme({
    this.primary = const Color(0xFF338ef7),
    this.primaryVariant = const Color(0xFF004493),
    this.secondary = const Color(0xFF9353d3),
    this.secondaryVariant = const Color(0xFF481878),
    this.background = const Color(0xFFF4F4F5),
    this.surface = const Color(0xFFFFFFFF),
    this.success = const Color(0xFF17c964),
    this.warning = const Color(0xFFf5a524),
    this.error = const Color(0xFFf31260),
    this.onPrimary = const Color(0xFFFFFFFF),
    this.onSecondary = const Color(0xFFFFFFFF),
    this.onBackground = const Color(0xFF52525b),
    this.onSurface = const Color(0xFF52525b),
    this.onError = const Color(0xFFFFFFFF),
    this.light = const Color(0xFFFFFFFF),
    this.dark = const Color(0xFF000000),
    this.grey = const Color(0xFF9ca3af),
    this.defaultBackground = const Color(0xFF000000),
    this.defaultForeground = const Color(0xFF9ca3af),
    this.dividerColor = const Color(0xFFe4e4e7),
    this.canvas = const Color(0xFFFFFFFF),
    this.onSuccess = const Color(0xFFFFFFFF),
    this.onWarning = const Color(0xFFFFFFFF),
    this.onErrorLight = const Color(0xFFFFFFFF),
  });
}

/// Utilities for controlling the font size of a widget
enum LukyFontSizeEnum {
  textXs(12.0),
  textSm(14.0),
  textBase(16.0),
  textLg(18.0),
  textXl(20.0),
  text2Xl(24.0),
  text3Xl(30.0),
  text4Xl(36.0),
  text5Xl(48.0),
  text6Xl(60.0),
  text7Xl(72.0),
  text8Xl(96.0),
  text9Xl(128.0);

  final double value;
  const LukyFontSizeEnum(this.value);
}

class LukyFontSize {
  double textXs = 12.0;
  double textSm = 14.0;
  double textBase = 16.0;
  double textLg = 18.0;
  double textXl = 20.0;
  double text2Xl = 24.0;
  double text3Xl = 30.0;
  double text4Xl = 36.0;
  double text5Xl = 48.0;
  double text6Xl = 60.0;
  double text7Xl = 72.0;
  double text8Xl = 96.0;
  double text9Xl = 128.0;
}

class LukyPadding {
  double xs = 4.0;
  double sm = 8.0;
  double md = 12.0;
  double lg = 16.0;
  double xl = 24.0;
}
