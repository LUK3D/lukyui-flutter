import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

enum LukyBadgeType {
  success,
  error,
  warning,
  info,
  primary,
  secondary,
}

class LukyBade extends StatelessWidget {
  final Widget child;
  final Offset offset;
  final LukyBadgeType type;
  final BorderRadius borderRadius;
  final EdgeInsets? padding;
  final Alignment alignment;
  final LukySize size;
  final Color? borderColor;
  final double? borderWidth;
  final bool isVisible;
  final String label;
  const LukyBade({
    super.key,
    required this.child,
    this.type = LukyBadgeType.error,
    this.offset = const Offset(-10, -10),
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding,
    this.alignment = Alignment.center,
    this.size = LukySize.xs,
    this.borderColor,
    this.borderWidth,
    this.isVisible = true,
    required this.label,
  });

  Color getColor(BuildContext context) {
    final theme = Luky.of(context).theme;
    switch (type) {
      case LukyBadgeType.success:
        return theme.colorScheme.success;
      case LukyBadgeType.error:
        return theme.colorScheme.error;
      case LukyBadgeType.warning:
        return theme.colorScheme.warning;
      case LukyBadgeType.primary:
        return theme.colorScheme.primary;
      case LukyBadgeType.secondary:
        return theme.colorScheme.secondary;
      case LukyBadgeType.info:
        return theme.colorScheme.primary;
    }
  }

  Color getForegroundColor(BuildContext context) {
    final theme = Luky.of(context).theme;
    switch (type) {
      case LukyBadgeType.success:
        return theme.colorScheme.onSuccess;
      case LukyBadgeType.error:
        return theme.colorScheme.onError;
      case LukyBadgeType.warning:
        return theme.colorScheme.onWarning;
      case LukyBadgeType.info:
        return theme.colorScheme.onPrimary;
      case LukyBadgeType.primary:
        return theme.colorScheme.onPrimary;
      case LukyBadgeType.secondary:
        return theme.colorScheme.onSecondary;
    }
  }

  Offset badgeOffset() {
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return Stack(
      clipBehavior: Clip.none,
      alignment: alignment,
      children: [
        child,
        if (isVisible)
          Positioned(
            top: badgeOffset().dy,
            right: badgeOffset().dx,
            child: Container(
              padding:
                  padding ?? EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              decoration: BoxDecoration(
                color: getColor(context),
                borderRadius: borderRadius,
                border: Border.all(
                  color: borderColor ?? theme.colorScheme.background,
                  width: borderWidth ?? 2,
                  strokeAlign: 1,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                    color: getForegroundColor(context),
                    fontSize: (getSize(size, context) ?? 10)),
              ),
            ),
          ),
      ],
    );
  }
}
