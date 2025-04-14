import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/theme/utils.dart';

/// The place where the widget is placed in the parent widget.
enum LukyPlacement {
  top,
  bottom,
  left,
  right,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center,
}

enum LukySize {
  xs,
  sm,
  md,
  lg,
  xl,
}

double? getSize(LukySize? size, BuildContext context) {
  if (size == null) {
    return null;
  }

  switch (size) {
    case LukySize.xs:
      return LukyFontSize().textXs;
    case LukySize.sm:
      return LukyFontSize().textSm;
    case LukySize.md:
      return LukyFontSize().textBase;
    case LukySize.lg:
      return LukyFontSize().textLg;
    case LukySize.xl:
      return LukyFontSize().textXl;
  }
}

EdgeInsets? getPaddings(LukySize? size, BuildContext context) {
  if (size == null) {
    return null;
  }
  final theme = Luky.of(context).theme;

  switch (size) {
    case LukySize.xs:
      return EdgeInsets.all(theme.padding.xs);
    case LukySize.sm:
      return EdgeInsets.all(theme.padding.sm);
    case LukySize.md:
      return EdgeInsets.all(theme.padding.md);
    case LukySize.lg:
      return EdgeInsets.all(theme.padding.lg);
    case LukySize.xl:
      return EdgeInsets.all(theme.padding.xl);
  }
}

/// Function to scale a BorderRadius by a given factor
BorderRadius? scaleBorderRadius(BorderRadius? radius, double factor) {
  if (radius == null) {
    return null;
  }
  return BorderRadius.only(
    topLeft:
        Radius.elliptical(radius.topLeft.x * factor, radius.topLeft.y * factor),
    topRight: Radius.elliptical(
        radius.topRight.x * factor, radius.topRight.y * factor),
    bottomLeft: Radius.elliptical(
        radius.bottomLeft.x * factor, radius.bottomLeft.y * factor),
    bottomRight: Radius.elliptical(
        radius.bottomRight.x * factor, radius.bottomRight.y * factor),
  );
}
