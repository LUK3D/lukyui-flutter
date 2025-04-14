import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

class LukyChip extends StatelessWidget {
  final String? label;
  final Widget? labelWidget;
  final Widget? startChild;
  final Widget? endChild;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? closeButtonBackground;
  final Color? closeButtonIconColor;
  final Color? labelColor;
  final Gradient? gradient;
  final BoxBorder? border;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final Function()? onPressed;
  final Function()? onClose;
  final EdgeInsets? padding;
  final LukySize? size;
  final LukyButtonVariant? variant;
  const LukyChip({
    super.key,
    this.label,
    this.labelWidget,
    this.backgroundColor,
    this.gradient,
    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.onPressed,
    this.onClose,
    this.labelStyle,
    this.padding,
    this.size,
    this.variant,
    this.labelColor,
    this.closeButtonBackground,
    this.closeButtonIconColor,
    this.startChild,
    this.endChild,
  }) : assert(
          label != null || labelWidget != null,
          "Either label or labelWidget must be provided.",
        );

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    final finalPadding = getPaddings(size ?? LukySize.sm, context);
    return LukyButton(
      onPressed: onPressed,
      borderRadius: borderRadius ?? BorderRadius.circular(100),
      variant: variant ?? LukyButtonVariant.shadow,
      backgroundColor: backgroundColor,
      foregroundColor:
          labelStyle?.color ?? (borderColor ?? theme.colorScheme.onPrimary),
      borderColor: borderColor,
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: finalPadding?.top ?? 0,
            vertical: (finalPadding?.top ?? 1) / 2,
          ),
      size: size ?? LukySize.xs,
      disabledOpacity: 1,
      child: Row(
        spacing: 7,
        children: [
          if (startChild != null) startChild!,
          if (label != null)
            Text(
              label!,
              style: labelStyle ??
                  TextStyle(
                    height: 1,
                    color: labelColor ??
                        (borderColor ?? theme.colorScheme.onPrimary),
                    fontSize: getSize(size ?? LukySize.xs, context),
                  ),
            ),
          if (labelWidget != null) labelWidget!,
          if (endChild != null) endChild!,
          if (onClose != null)
            LukyButton(
              onPressed: onClose,
              padding: EdgeInsets.all(0),
              backgroundColor: closeButtonBackground,
              child: Icon(
                Icons.close,
                size: (getSize(size ?? LukySize.xs, context) ?? 10),
                color: closeButtonIconColor ??
                    (labelColor ??
                        (borderColor ?? theme.colorScheme.onPrimary)),
              ),
            ),
        ],
      ),
    );
  }
}
