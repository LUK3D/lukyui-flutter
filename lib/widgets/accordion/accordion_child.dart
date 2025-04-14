import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';
import 'package:simple_animations/simple_animations.dart';

class AccordionChild extends StatefulWidget {
  final LukyAccordionItemModel item;
  final Widget Function(
    LukyAccordionItemModel,
    Function toggleExpand,
  )? descriptionBuilder;
  final Widget Function(
    LukyAccordionItemModel,
    Function toggleExpand,
  )? titleBuilder;
  final Widget? icon;
  final bool isExpanded;
  final Function(bool)? onToggle;
  final bool showBottomBorder;
  final EdgeInsets? padding;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final BorderRadius? borderRadius;
  final BoxDecoration? decoration;
  final Curve? animationCurve;
  final Duration? animationDuration;

  const AccordionChild({
    super.key,
    this.titleBuilder,
    this.descriptionBuilder,
    this.icon,
    this.isExpanded = false,
    this.onToggle,
    this.showBottomBorder = true,
    required this.item,
    this.padding,
    this.titleStyle,
    this.descriptionStyle,
    this.borderRadius,
    this.decoration,
    this.animationCurve,
    this.animationDuration,
  });

  @override
  State<AccordionChild> createState() => _AccordionChildState();
}

class _AccordionChildState extends State<AccordionChild>
    with SingleTickerProviderStateMixin {
  late Control control;

  void toggleDirection() {
    setState(() {
      control = control == Control.play ? Control.playReverse : Control.play;
    });
    widget.onToggle?.call(control == Control.play);
  }

  @override
  void initState() {
    super.initState();
    control = widget.isExpanded ? Control.play : Control.stop;
  }

  @override
  Widget build(BuildContext context) {
    final themer = Luky.of(context).theme;

    return CustomAnimationBuilder<double>(
      control: control,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: widget.animationDuration ?? const Duration(milliseconds: 300),
      curve: widget.animationCurve ?? Curves.easeInOut,
      builder: (context, value, child) {
        double indicatorRotationValue = (value * 1.57);
        return Container(
          padding: widget.padding ??
              EdgeInsets.symmetric(
                horizontal: getPaddings(LukySize.md, context)?.right ?? 0,
              ),
          decoration: widget.decoration ??
              BoxDecoration(
                color: themer.colorScheme.surface,
                borderRadius: widget.borderRadius,
                border: widget.showBottomBorder
                    ? Border(
                        bottom: BorderSide(
                          color: themer.colorScheme.dividerColor,
                        ),
                      )
                    : null,
              ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: toggleDirection,
                  child: (widget.titleBuilder != null)
                      ? widget.titleBuilder!(widget.item, toggleDirection)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.icon != null) widget.icon!,
                            Expanded(
                              child: Text(
                                widget.item.title,
                                style: widget.titleStyle ??
                                    TextStyle(
                                      fontSize: themer.fontSize.textLg,
                                      fontWeight: FontWeight.w600,
                                      color: themer.colorScheme.onSurface,
                                    ),
                              ),
                            ),
                            LukyButton(
                              padding: getPaddings(LukySize.sm, context),
                              variant: LukyButtonVariant.light,
                              onPressed: toggleDirection,
                              child: Transform.rotate(
                                angle: 1.6,
                                child: Transform.rotate(
                                  angle: indicatorRotationValue,
                                  child: Icon(
                                    Icons.expand_more_rounded,
                                    color: themer.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),

              ClipRect(
                child: Opacity(
                  opacity: value,
                  child: Align(
                    heightFactor: clampDouble(value, 0, 1),
                    alignment: Alignment.topLeft,
                    child: Transform.translate(
                      offset: Offset(0, -value * 5),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: getPaddings(LukySize.sm, context)!.bottom),
                        child: widget.descriptionBuilder != null
                            ? widget.descriptionBuilder!(
                                widget.item, toggleDirection)
                            : Text(
                                widget.item.description,
                                style: widget.descriptionStyle ??
                                    TextStyle(
                                      fontSize: themer.fontSize.textBase,
                                      color: themer.colorScheme.onSurface,
                                    ),
                              ),
                      ),
                    ),
                  ),
                ),
              )

              /// Description
            ],
          ),
        );
      },
    );
  }
}
