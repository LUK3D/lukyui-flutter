import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';
import 'package:simple_animations/simple_animations.dart';

import '../dialogs/popover_controller.dart';

class LukyAutoCompleteResultContainer<T> extends StatefulWidget {
  final RenderBox box;
  final LukyPopoverController popoverController;
  final BorderRadius? borderRadius;
  final TextEditingController inputController;
  final List<LukyAutocompleteModel<T>> items;
  final List<LukyAutocompleteModel<T>> selectedItems;
  final void Function(List<LukyAutocompleteModel<T>> item) onSelectionUpdate;
  final bool canSelectMultiple;
  final Curve? animationCurve;
  final Duration? animationDuration;
  final BorderRadius? dialogBorderRadius;
  final double? widthCompensation;
  final LukyAutocompleteVariant variant;
  final double? borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double spacing;
  final Widget Function(LukyAutocompleteModel<T> item, bool selected,
      Function onTap, double animationValue)? itemBuilder;
  final double maxDialogHeight;
  final bool showSelectionIcon;

  const LukyAutoCompleteResultContainer({
    super.key,
    this.borderRadius,
    required this.box,
    required this.popoverController,
    required this.inputController,
    required this.items,
    required this.selectedItems,
    required this.onSelectionUpdate,
    this.canSelectMultiple = false,
    this.animationCurve,
    this.animationDuration,
    this.dialogBorderRadius,
    this.widthCompensation,
    this.variant = LukyAutocompleteVariant.flat,
    this.borderWidth,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor,
    this.itemBuilder,
    required this.maxDialogHeight,
    this.spacing = 0,
    this.showSelectionIcon = true,
  });

  @override
  State<LukyAutoCompleteResultContainer<T>> createState() =>
      _LukyAutoCompleteResultContainerState<T>();
}

class _LukyAutoCompleteResultContainerState<T>
    extends State<LukyAutoCompleteResultContainer<T>> {
  late String searchTerm = widget.inputController.text;
  late List<LukyAutocompleteModel<T>> _selectedItems;

  @override
  void initState() {
    super.initState();
    widget.inputController.addListener(onContentChange);
    _selectedItems = widget.selectedItems;
  }

  @override
  void dispose() {
    widget.inputController.removeListener(onContentChange);
    super.dispose();
  }

  onContentChange() {
    debugPrint(widget.inputController.text);
    setState(() {
      searchTerm = widget.inputController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return PlayAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1),
        duration: widget.animationDuration ?? const Duration(milliseconds: 300),
        curve: widget.animationCurve ?? Curves.easeIn,
        builder: (context, value, _) {
          final data = widget.items.where((e) {
            return e.searchableContent
                .toLowerCase()
                .contains(searchTerm.toLowerCase());
          }).map((item) {
            onSelectItem() {
              setState(() {
                //Check if the item is already in the list
                final foundItem =
                    _selectedItems.where((e) => e.value == item.value).toList();

                if (foundItem.isNotEmpty) {
                  _selectedItems.removeWhere(
                      (e) => foundItem.map((e2) => e2.value).contains(e.value));
                } else {
                  if (widget.canSelectMultiple != true) {
                    _selectedItems.clear();
                  }
                  _selectedItems.add(item);
                }
              });

              widget.onSelectionUpdate(_selectedItems);
            }

            final selected =
                _selectedItems.where((e) => e.value == item.value).isNotEmpty;

            if (widget.itemBuilder != null) {
              return Stack(
                alignment: Alignment.centerRight,
                children: [
                  widget.itemBuilder!(item, selected, onSelectItem, value),
                  if (widget.showSelectionIcon)
                    Positioned(
                      right: 10,
                      child: selected
                          ? PlayAnimationBuilder<double?>(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              builder: (context, value, _) {
                                return Transform.scale(
                                  scale: value,
                                  child: Icon(
                                    selected
                                        ? Icons.check_circle
                                        : Icons.circle,
                                    color: selected
                                        ? theme.colorScheme.success
                                        : theme.colorScheme.surface,
                                  ),
                                );
                              })
                          : SizedBox(),
                    )
                ],
              );
            }
            return LukyButton(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              width: double.infinity,
              variant: LukyButtonVariant.light,
              foregroundColor:
                  widget.foregroundColor ?? theme.colorScheme.onSurface,
              onPressed: onSelectItem,
              endChild: (widget.showSelectionIcon &&
                      _selectedItems
                          .where((e) => e.value == item.value)
                          .isNotEmpty)
                  ? Icon(
                      Icons.check_circle_outlined,
                      color:
                          widget.foregroundColor ?? theme.colorScheme.onSurface,
                      size: getSize(LukySize.lg, context),
                    )
                  : null,
              label: item.title,
            );
          }).toList();
          return Transform.scale(
            origin: Offset(0, (-widget.box.localToGlobal(Offset.zero).dy + 10)),
            scale: clampDouble(value + 0.8, .5, 1),
            child: Opacity(
              opacity: value,
              child: Material(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  side: widget.variant == LukyAutocompleteVariant.bordered
                      ? BorderSide(
                          color: widget.borderColor ??
                              theme.colorScheme.dividerColor,
                          width: widget.borderWidth ?? 1,
                        )
                      : BorderSide.none,
                  borderRadius: widget.dialogBorderRadius ??
                      widget.borderRadius ??
                      BorderRadius.circular(
                          getSize(LukySize.sm, context) ?? 10),
                ),
                elevation: 6,
                color: widget.backgroundColor ?? theme.colorScheme.surface,
                shadowColor: theme.colorScheme.dividerColor,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: widget.maxDialogHeight,
                  ),
                  child: SizedBox(
                    width: widget.box.size.width +
                        (widget.widthCompensation ?? 14),
                    child: ListView.builder(
                      itemCount: data.length,
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: widget.spacing,
                          ),
                          child: data[index],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
