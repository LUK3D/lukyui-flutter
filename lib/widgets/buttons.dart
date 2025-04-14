import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

/// ## LukyButtonVariant
/// Different styles of buttons.
/// - solid: Solid background color with text color
/// - faded: Faded background color with text color
/// - bordered: Bordered button with text color
/// - light: Light background color with text color
/// - flat: Flat button with text color
/// - ghost: Transparent button with text color
/// - shadow: Shadow button with text color
enum LukyButtonVariant {
  solid,
  faded,
  bordered,
  light,
  flat,
  ghost,
  shadow,
}

/// ## LukyButton
/// A customizable button widget that can be used in your app.
/// It supports different styles, sizes, and placements.
///
/// It also supports loading state and custom child widgets.
///
/// ## Example
/// ```dart
/// LukyButton(
///   label: "Medium",
///   onPressed: () {
///     debugPrint("Hello World");
///   },
///   spacing: 4,
///   size: LukySize.md,
/// ),
/// ```
class LukyButton extends StatelessWidget {
  /// The child widget to be displayed inside the button.
  /// If [label] is provided, this will be ignored.
  final Widget? child;

  /// The text label to be displayed inside the button.
  /// If [child] is provided, this will be ignored.
  final String? label;

  /// The callback function to be called when the button is pressed.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The background color of the button.
  /// If null, the default color will be used based on the variant.
  final Color? backgroundColor;

  /// The text color of the button.
  /// If null, the default color will be used based on the variant.
  final Color? foregroundColor;

  /// The border color of the button.
  final Color? borderColor;

  /// The width of the button.
  final double? width;

  /// The height of the button.
  final double? height;

  /// The widget to be displayed at the start of the button.
  final Widget? startChild;

  /// The widget to be displayed at the end of the button.
  final Widget? endChild;

  /// The loading state of the button.
  final bool? isLoading;

  /// The padding of the button.
  final EdgeInsets? padding;

  /// The button's border radius.
  final BorderRadius? borderRadius;

  final double? borderWidth;

  /// The elevation of the button.
  final double? elevation;

  /// The shadow color of the button.
  final Color? shadowColor;

  /// The size of the button.
  /// If provided, it will override the width and height.
  final LukySize? size;

  /// The spacing between the child widgets.
  final double? spacing;

  /// The main axis alignment of the button.
  final MainAxisAlignment? mainAxisAlignment;

  /// The main axis size of the button.
  final MainAxisSize? mainAxisSize;

  /// The cross axis alignment of the button.
  final CrossAxisAlignment? crossAxisAlignment;

  /// The direction of the button.
  final Axis? direction;

  /// The variant of the button.
  /// This determines the style of the button.
  final LukyButtonVariant? variant;

  /// The background gradient of the button.
  /// If provided, it will override the background color.
  final Gradient? backgroundGradient;

  final Clip? clipBehavior;

  final double? disabledOpacity;

  LukyButton({
    super.key,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.width,
    this.height,
    this.startChild,
    this.endChild,
    this.isLoading,
    this.padding,
    this.borderRadius,
    this.label,
    this.elevation,
    this.shadowColor,
    this.size,
    this.spacing,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.crossAxisAlignment,
    this.direction,
    this.variant = LukyButtonVariant.solid,
    this.backgroundGradient,
    this.borderWidth,
    this.clipBehavior,
    this.disabledOpacity,
  }) {
    assert(
      child != null || label != null,
      'Either child or label must be provided',
    );
    assert(
      !(child != null && label != null),
      'Only one of child or label can be provided',
    );

    assert(
      !((width != null || height != null) && size != null),
      'Either width and height or size must be provided',
    );
  }

  Widget getparentLayout(List<Widget> children) {
    if (direction == Axis.vertical) {
      return Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        spacing: spacing ?? 0,
        children: children,
      );
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      spacing: spacing ?? 0,
      children: children,
    );
  }

  Color? getBackground(BuildContext context) {
    final theme = Luky.of(context).theme;
    if (variant == LukyButtonVariant.solid) {
      return backgroundColor ?? theme.colorScheme.defaultBackground;
    }
    if (variant == LukyButtonVariant.faded) {
      return backgroundColor ?? theme.colorScheme.grey.withAlpha(50);
    }
    if (variant == LukyButtonVariant.bordered) {
      return backgroundColor ?? Colors.transparent;
    }
    if (variant == LukyButtonVariant.light) {
      return backgroundColor ?? Colors.transparent;
    }
    if (variant == LukyButtonVariant.flat) {
      return (backgroundColor ?? theme.colorScheme.primary).withAlpha(100);
    }
    if (variant == LukyButtonVariant.ghost) {
      return backgroundColor ?? Colors.transparent;
    }
    if (variant == LukyButtonVariant.shadow) {
      return backgroundColor ?? theme.colorScheme.primary;
    }
    return null;
  }

  Color getForeground(BuildContext context) {
    final theme = Luky.of(context).theme;
    if (variant == LukyButtonVariant.solid) {
      return foregroundColor ?? theme.colorScheme.defaultForeground;
    }
    if (variant == LukyButtonVariant.faded) {
      return foregroundColor ?? theme.colorScheme.grey;
    }
    if (variant == LukyButtonVariant.bordered) {
      return foregroundColor ?? theme.colorScheme.primary;
    }
    if (variant == LukyButtonVariant.light) {
      return foregroundColor ?? theme.colorScheme.onSurface;
    }
    if (variant == LukyButtonVariant.flat) {
      return foregroundColor ?? theme.colorScheme.primary;
    }
    if (variant == LukyButtonVariant.ghost) {
      return foregroundColor ?? theme.colorScheme.primary;
    }
    if (variant == LukyButtonVariant.shadow) {
      return foregroundColor ?? theme.colorScheme.light;
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return Opacity(
      opacity: onPressed == null ? (disabledOpacity ?? 0.6) : 1.0,
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundGradient,
            borderRadius: borderRadius ?? theme.buttonBorderradius,
          ),
          child: Material(
            borderRadius: (variant != LukyButtonVariant.ghost &&
                    variant != LukyButtonVariant.bordered &&
                    variant != LukyButtonVariant.faded)
                ? (borderRadius ?? theme.buttonBorderradius)
                : null,
            color: backgroundGradient != null
                ? Colors.transparent
                : getBackground(context),
            elevation:
                elevation ?? (variant == LukyButtonVariant.shadow ? 6 : 0),
            shadowColor:
                shadowColor ?? (backgroundColor ?? theme.colorScheme.primary),
            clipBehavior: clipBehavior ?? Clip.none,
            shape: ((variant != LukyButtonVariant.ghost &&
                        variant != LukyButtonVariant.bordered &&
                        variant != LukyButtonVariant.faded) ||
                    backgroundGradient != null)
                ? null
                : RoundedRectangleBorder(
                    borderRadius: borderRadius ?? theme.buttonBorderradius,
                    side: BorderSide(
                      color: borderColor ??
                          (variant == LukyButtonVariant.faded
                              ? theme.colorScheme.grey.withAlpha(150)
                              : getForeground(context)),
                      width: borderWidth ?? 2,
                    ),
                  ),
            child: InkWell(
              borderRadius: borderRadius ?? theme.buttonBorderradius,
              onTap: onPressed,
              splashColor: getForeground(context).withAlpha(100),
              child: Padding(
                padding: padding ??
                    (getPaddings(size, context) ??
                        const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        )),
                child: getparentLayout(
                  [
                    if (isLoading == true)
                      SizedBox(
                        width: getSize(size ?? LukySize.sm, context),
                        height: getSize(size ?? LukySize.sm, context),
                        child: CircularProgressIndicator(
                          color: foregroundColor ?? getForeground(context),
                          strokeWidth: 2,
                          value: null,
                        ),
                      ),
                    if (startChild != null) startChild!,
                    if (label == null) child!,
                    if (label != null)
                      Text(
                        label!,
                        style: TextStyle(
                          color: getForeground(context),
                          fontSize: getSize(size, context),
                        ),
                      ),
                    if (endChild != null) endChild!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
