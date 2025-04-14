import 'package:flutter/material.dart';
import 'utils.dart';

class LukyThemeData {
  LukyColorScheme colorScheme = LukyColorScheme();
  BorderRadius buttonBorderradius = BorderRadius.circular(8.0);
  LukyFontSize fontSize = LukyFontSize();
  LukyPadding padding = LukyPadding();

  LukyThemeData({
    LukyColorScheme? colorScheme,
    LukyFontSize? fontSize,
    LukyPadding? padding,
  }) {
    if (colorScheme != null) {
      this.colorScheme = colorScheme;
    }
    if (fontSize != null) {
      this.fontSize = fontSize;
    }
    if (padding != null) {
      this.padding = padding;
    }
  }

  LukyThemeData copyWith({
    LukyColorScheme? colorScheme,
    BorderRadius? buttonBorderradius,
    LukyFontSize? fontSize,
    LukyPadding? padding,
  }) {
    return LukyThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      fontSize: fontSize ?? this.fontSize,
      padding: padding ?? this.padding,
    );
  }
}
