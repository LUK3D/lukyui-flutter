import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';
import 'package:simple_animations/simple_animations.dart';
import '../dialogs/popover_controller.dart';
import 'result_container.dart';

/// ## LukyAutocomplete
/// A customizable autocomplete widget that supports both single and multiple selection.
///
/// This widget provides a text input field with dropdown suggestions based on user input.
/// It supports various customization options including styling, selection behavior, and item rendering.
class LukyAutocomplete<T> extends StatefulWidget {
  /// The border radius of the input field.
  final BorderRadius? inputBorderRadius;

  /// Controller for the text input field.
  final TextEditingController? inputController;

  /// Callback triggered when the input text changes.
  final Function(String)? onContentChange;

  /// Callback triggered when the focus state of the input field changes.
  final Function(bool)? onFocusChange;

  /// Callback triggered when selected items are updated.
  final Function(List<LukyAutocompleteModel<T>> items)? onSelectionUpdate;

  /// The list of items available for selection in the dropdown.
  final List<LukyAutocompleteModel<T>> items;

  /// The currently selected items.
  final List<LukyAutocompleteModel<T>> selectedItems;

  /// Whether multiple items can be selected at once.
  final bool canSelectMultiple;

  /// Widget to display as the input field label.
  final Widget? inputLabel;

  /// Padding applied to the input field.
  final EdgeInsets? inputPadding;

  /// The width of the autocomplete widget.
  final double? width;

  /// The height of the autocomplete widget.
  final double? height;

  /// The width of the border for the input field.
  final double? borderWidth;

  /// The color of the border for the input field.
  final Color? borderColor;

  /// The width of the border for the dropdown dialog.
  final double? dialogBorderWidth;

  /// The spacing between items in the dropdown list.
  final double? itemSpacing;

  /// The color of the border for the dropdown dialog.
  final Color? dialogBorderColor;

  /// Custom decoration for the input field container.
  final BoxDecoration? inputDecoration;

  /// Placeholder text shown in the input field when empty.
  final String? hintText;

  /// The border radius of the dropdown dialog.
  final BorderRadius? dialogBorderRadius;

  /// Widget to display at the trailing end of the input field.
  final Widget? trailWidget;

  /// The visual style variant of the autocomplete widget.
  final LukyAutocompleteVariant variant;

  /// Background color of the input field.
  final Color? backgroundColor;

  /// Background color of the dropdown dialog.
  final Color? dialogBackgroundColor;

  /// Text and icon color of the input field.
  final Color? foregroundColor;

  /// Text and icon color of the dropdown dialog.
  final Color? dialogForegroundColor;

  /// The maximum height of the dropdown dialog.
  final double maxDialogHeight;

  /// Whether to show selection indicators for items.
  final bool showSelectionIcon;

  /// The widget to be displayed at the start of the input field.
  final Widget? startChild;

  /// The widget to be displayed at the end of the input field.
  final Widget? endChild;

  /// Custom builder function for dropdown items.
  ///
  /// Receives the item model, selection state, tap callback, and animation value.
  final Widget Function(
    LukyAutocompleteModel<T> item,
    bool selected,
    Function onTap,
    double animationValue,
  )? itemBuilder;

  /// Creates a LukyAutocomplete widget.
  ///
  /// The [items] and [selectedItems] parameters are required.
  const LukyAutocomplete({
    super.key,
    this.inputBorderRadius,
    this.inputController,
    this.onContentChange,
    this.onFocusChange,
    this.onSelectionUpdate,
    this.canSelectMultiple = true,
    required this.items,
    required this.selectedItems,
    this.inputLabel,
    this.inputPadding,
    this.width,
    this.height,
    this.inputDecoration,
    this.hintText,
    this.dialogBorderRadius,
    this.trailWidget,
    this.variant = LukyAutocompleteVariant.flat,
    this.borderWidth,
    this.borderColor,
    this.dialogBorderWidth,
    this.dialogBorderColor,
    this.backgroundColor,
    this.dialogBackgroundColor,
    this.foregroundColor,
    this.dialogForegroundColor,
    this.itemBuilder,
    this.maxDialogHeight = 500,
    this.itemSpacing,
    this.showSelectionIcon = true,
    this.startChild,
    this.endChild,
  });

  @override
  State<LukyAutocomplete<T>> createState() => _LukyAutocompleteState();
}

class _LukyAutocompleteState<T> extends State<LukyAutocomplete<T>> {
  late Control control = Control.stop;
  var focusOn = false;
  FocusNode focusNode = FocusNode();
  final popover = LukyPopoverController();
  final GlobalKey _autocompleteKey = GlobalKey();
  late TextEditingController inputController =
      widget.inputController ?? TextEditingController();
  late List<LukyAutocompleteModel<T>> selectedItems = widget.selectedItems;
  bool dropDownVisible = false;
  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        focusOn = focusNode.hasFocus;
      });
      focusListener(focusOn);
      widget.onFocusChange?.call(focusOn);
    });

    inputController.addListener(() {
      inputListener();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    inputController.removeListener(inputListener);
    inputController.dispose();
    super.dispose();
  }

  inputListener() {
    if (inputController.text.isNotEmpty) {
      if (!dropDownVisible) {
        focusListener(true);
      }
      widget.onContentChange?.call(inputController.text);
    }
  }

  focusListener(bool hasFocus) {
    final box =
        _autocompleteKey.currentContext!.findRenderObject() as RenderBox;
    if (hasFocus) {
      popover.show(
        context: context,
        targetBox: box,
        onDismiss: () {
          dropDownVisible = false;
          toggleDirection();
        },
        offset: Offset(0, 5),
        builder: (_) {
          return LukyAutoCompleteResultContainer<T>(
            itemBuilder: widget.itemBuilder,
            box: box,
            spacing: widget.itemSpacing ?? 0,
            popoverController: popover,
            inputController: inputController,
            selectedItems: selectedItems,
            canSelectMultiple: widget.canSelectMultiple,
            dialogBorderRadius: widget.dialogBorderRadius,
            variant: widget.variant,
            borderRadius: widget.dialogBorderRadius,
            borderColor: widget.dialogBorderColor,
            borderWidth: widget.dialogBorderWidth,
            backgroundColor: widget.dialogBackgroundColor,
            foregroundColor: widget.dialogForegroundColor,
            maxDialogHeight: widget.maxDialogHeight,
            showSelectionIcon: widget.showSelectionIcon,
            onSelectionUpdate: (items) {
              setState(() {
                selectedItems = items;
              });
              widget.onSelectionUpdate?.call(items);
            },
            items: widget.items,
          );
        },
      );
      setState(() {
        dropDownVisible = true;
      });
    }
    toggleDirection();
  }

  void toggleDirection() {
    setState(() {
      control = (!dropDownVisible) ? Control.playReverse : Control.play;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return Stack(
      children: [
        Container(
          key: _autocompleteKey,
          width: widget.width ?? 400,
          height: widget.height ?? 50,
          decoration: widget.inputDecoration ??
              BoxDecoration(
                color: widget.backgroundColor ?? theme.colorScheme.surface,
                borderRadius: widget.inputBorderRadius ??
                    BorderRadius.circular(getSize(LukySize.xs, context) ?? 10),
                border: widget.variant == LukyAutocompleteVariant.bordered
                    ? Border.all(
                        color: widget.borderColor ??
                            theme.colorScheme.dividerColor,
                        width: widget.borderWidth ?? 2,
                      )
                    : null,
              ),
          child: InkWell(
            borderRadius: widget.inputBorderRadius ??
                BorderRadius.circular(getSize(LukySize.xs, context) ?? 10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.startChild != null) widget.startChild!,
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: inputController,
                      style: TextStyle(
                        color: widget.foregroundColor ??
                            theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        label: widget.inputLabel,
                        hintText: widget.hintText ?? "Type to search...",
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            widget.inputPadding ?? EdgeInsets.all(5),
                        hintStyle: TextStyle(
                          color: widget.foregroundColor?.withAlpha(200) ??
                              theme.colorScheme.onSurface,
                        ),
                        labelStyle: TextStyle(
                          color: widget.foregroundColor ??
                              theme.colorScheme.onSurface,
                        ),
                      ),
                      cursorColor:
                          widget.foregroundColor ?? theme.colorScheme.onSurface,
                    ),
                  ),
                  if (widget.endChild != null) widget.endChild!,
                  CustomAnimationBuilder<double>(
                    control: control,
                    tween: Tween<double>(begin: -1.6, end: 1.6),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: 1.6,
                        child: Transform.rotate(
                          angle: value,
                          child: widget.trailWidget ??
                              Icon(
                                Icons.expand_more_rounded,
                                color: widget.foregroundColor ??
                                    theme.colorScheme.onSurface,
                              ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
