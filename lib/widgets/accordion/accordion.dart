import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

class LukyAccordion extends StatelessWidget {
  final List<LukyAccordionItemModel> items;
  final Function(LukyAccordionItemModel item, bool state)? onItemToggle;
  final Widget Function(
    LukyAccordionItemModel item,
    Function toggleExpand,
  )? descriptionBuilder;
  final Widget Function(
    LukyAccordionItemModel item,
    Function toggleExpand,
  )? titleBuilder;
  final Widget Function(
    LukyAccordionItemModel item,
  )? iconBuilder;
  final EdgeInsets? itemPadding;
  final EdgeInsets? containerPadding;
  final BoxDecoration? containerDecoration;
  final BoxDecoration? itemDecoration;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final BorderRadius? itemBorderRadius;
  final bool showChildBottomBorder;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final double? itemSpacing;

  const LukyAccordion({
    super.key,
    this.titleBuilder,
    this.descriptionBuilder,
    this.onItemToggle,
    required this.items,
    this.itemPadding,
    this.containerDecoration,
    this.iconBuilder,
    this.containerPadding,
    this.titleStyle,
    this.descriptionStyle,
    this.itemBorderRadius,
    this.itemDecoration,
    this.showChildBottomBorder = true,
    this.animationCurve,
    this.animationDuration,
    this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final themer = Luky.of(context).theme;
    return Container(
      padding: containerPadding,
      clipBehavior: Clip.antiAlias,
      decoration: containerDecoration ??
          BoxDecoration(
              borderRadius:
                  BorderRadius.circular(getSize(LukySize.xs, context) ?? 5),
              //rounded corners
              border: Border.all(
                width: 1,
                strokeAlign: 1,
                color: themer.colorScheme.dividerColor,
              )),
      child: Column(
        spacing: itemSpacing ?? 0,
        children: items.map((item) {
          return AccordionChild(
            item: item,
            icon: iconBuilder != null
                ? iconBuilder!(item)
                : Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.add,
                      color: themer.colorScheme.onSurface,
                    ),
                  ),
            isExpanded: item.isExpanded,
            onToggle: (isExpanded) {
              onItemToggle?.call(item, isExpanded);
            },
            borderRadius: itemBorderRadius,
            decoration: itemDecoration,
            showBottomBorder: (showChildBottomBorder && item != items.last),
            titleBuilder: titleBuilder,
            descriptionBuilder: descriptionBuilder,
            padding: itemPadding,
            descriptionStyle: descriptionStyle,
            titleStyle: titleStyle,
            animationCurve: animationCurve,
            animationDuration: animationDuration,
          );
        }).toList(),
      ),
    );
  }
}
