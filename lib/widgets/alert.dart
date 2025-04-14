import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

enum LukyAlertType {
  basic,
  primary,
  secondary,
  success,
  error,
  warning,
}

enum LukyAlertVariant {
  solid,
  bordered,
  faded,
  flat,
}

class LukyAlert extends StatelessWidget {
  final LukyAlertType type;
  final LukyAlertVariant variant;
  final BoxDecoration? decoration;
  final Color? backgroundColor;
  final Widget? startChild;
  final Widget? endChild;
  final String? title;
  final String? description;
  final Widget? icon;
  final Widget? titleWidget;
  final Widget? descriptionWidget;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final double? spacing;
  final EdgeInsets? padding;
  final bool hideIcon;
  final bool isVisible;

  LukyAlert({
    super.key,
    this.type = LukyAlertType.basic,
    this.variant = LukyAlertVariant.flat,
    this.decoration,
    this.backgroundColor,
    this.startChild,
    this.endChild,
    this.title,
    this.description,
    this.icon,
    this.titleWidget,
    this.descriptionWidget,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.borderWidth = 2,
    this.borderRadius,
    this.spacing,
    this.padding,
    this.hideIcon = true,
    this.isVisible = true,
  }) {
    assert(
      (title != null || titleWidget != null),
      "Either title or titleWidget must be provided",
    );
    assert(
      (description == null || descriptionWidget == null),
      "Provide description or descriptionWidget. Not both",
    );
  }

  Color getColor(BuildContext context) {
    final theme = Luky.of(context).theme;
    switch (type) {
      case LukyAlertType.success:
        return theme.colorScheme.success;
      case LukyAlertType.error:
        return theme.colorScheme.error;
      case LukyAlertType.warning:
        return theme.colorScheme.warning;
      case LukyAlertType.primary:
        return theme.colorScheme.primary;
      case LukyAlertType.secondary:
        return theme.colorScheme.secondary;
      case LukyAlertType.basic:
        return theme.colorScheme.onSurface;
    }
  }

  Color? getTextColor(BuildContext context) {
    final theme = Luky.of(context).theme;
    switch (variant) {
      case LukyAlertVariant.solid:
        return theme.colorScheme.light;
      default:
        return null;
    }
  }

  double getBackgroundOpacityValue(BuildContext context) {
    if (variant == LukyAlertVariant.solid) {
      return 1;
    }

    if (variant == LukyAlertVariant.bordered) {
      return 0.0;
    }

    if (variant == LukyAlertVariant.faded) {
      return 0.2;
    }

    if (variant == LukyAlertVariant.flat) {
      return 0.2;
    }
    return 1;
  }

  double getBorderOpacityValue(BuildContext context) {
    if (variant == LukyAlertVariant.solid) {
      return 1;
    }

    if (variant == LukyAlertVariant.bordered) {
      return 1;
    }

    if (variant == LukyAlertVariant.faded) {
      return 0.5;
    }

    if (variant == LukyAlertVariant.flat) {
      return 0.0;
    }
    return 1;
  }

  Widget getIcon(BuildContext context, Color color) {
    if (type == LukyAlertType.basic) {
      return Icon(
        Icons.info_outline_rounded,
        size: 16,
        color: color,
      );
    }
    if (type == LukyAlertType.success) {
      return Icon(
        Icons.check_circle_outline_rounded,
        size: 16,
        color: color,
      );
    }
    if (type == LukyAlertType.error) {
      return Icon(
        Icons.error_outline_rounded,
        size: 16,
        color: color,
      );
    }
    if (type == LukyAlertType.warning) {
      return Icon(
        Icons.warning_amber_rounded,
        size: 16,
        color: color,
      );
    }
    if (type == LukyAlertType.primary) {
      return Icon(
        Icons.info_outline_rounded,
        size: 16,
        color: color,
      );
    }
    return Icon(
      Icons.info_outline_rounded,
      size: 16,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color alertColor = getColor(context);
    final theme = Luky.of(context).theme;

    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Material(
      color: theme.colorScheme.background,
      borderRadius: borderRadius ??
          BorderRadius.circular(getSize(LukySize.xs, context) ?? 10),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: alertColor.withValues(alpha: getBackgroundOpacityValue(context)),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ??
              BorderRadius.circular(getSize(LukySize.xs, context) ?? 10),
          side: BorderSide(
            color: alertColor.withValues(alpha: getBorderOpacityValue(context)),
            width: borderWidth,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(8.0),
          child: Row(
            spacing: spacing ?? (getSize(LukySize.xs, context) ?? 10),
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              if (startChild != null) startChild!,
              if (hideIcon)
                CircleAvatar(
                  radius: 15,
                  backgroundColor:
                      (getTextColor(context) ?? alertColor).withAlpha(80),
                  child: icon ??
                      getIcon(context, getTextColor(context) ?? alertColor),
                ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "This is an alert!",
                      style: TextStyle(
                          color: getTextColor(context) ?? alertColor,
                          fontWeight: FontWeight.w500),
                    ),
                    if (descriptionWidget != null)
                      descriptionWidget!
                    else if (description != null)
                      Text(
                        description!,
                        style: TextStyle(
                          color: (getTextColor(context) ?? alertColor),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                ),
              ),
              // Spacer(),
              if (endChild != null) endChild!,
            ],
          ),
        ),
      ),
    );
  }
}
