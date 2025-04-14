import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/shadow.dart';
import 'package:lukyui/utils/utils.dart';

enum LukyTextInputType {
  text,
  number,
  integer,
  decimal,
  email,
  password,
  phone,
  url,
  date,
  time,
  datetime,
  search,
}

class LukyTextInput extends StatefulWidget {
  final Color? borderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool? debug;
  final Offset? labelOffse;
  final Offset? animatedLabelOffse;
  final Widget? label;
  final String? labelText;
  final double? width;
  final double? height;
  final InputBorder? inputBorder;
  final BorderRadius? borderRadius;
  final TextEditingController? controller;
  final InputDecoration? inputDecoration;
  final Widget? startChild;
  final Widget? endChild;
  final EdgeInsets? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final BoxDecoration? labelDecoration;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? labelShadow;
  final String? hint;
  final bool animated;
  final LukyTextInputType inputType;
  final double dragValueFactor;
  final bool enableValueDrag;
  const LukyTextInput(
      {super.key,
      this.borderColor,
      this.borderWidth,
      this.backgroundColor,
      this.foregroundColor,
      this.debug,
      this.labelOffse,
      this.label,
      this.labelText,
      this.width,
      this.height,
      this.inputBorder,
      this.borderRadius,
      this.controller,
      this.animatedLabelOffse,
      this.inputDecoration,
      this.startChild,
      this.endChild,
      this.contentPadding,
      this.focusedBorder,
      this.disabledBorder,
      this.focusedErrorBorder,
      this.errorBorder,
      this.labelDecoration,
      this.labelStyle,
      this.textStyle,
      this.boxShadow,
      this.labelShadow,
      this.hint,
      this.animated = true,
      this.inputType = LukyTextInputType.text,
      this.dragValueFactor = 1,
      this.enableValueDrag = true});

  @override
  State<LukyTextInput> createState() => _LukyTextInputState();
}

class _LukyTextInputState extends State<LukyTextInput> {
  late InputBorder inputBorder;
  FocusNode focusNode = FocusNode();
  late bool hasFocus = !widget.animated;
  late final controller = widget.controller ?? TextEditingController();
  late LukyTextInputType keyboardType = widget.inputType;

  double mouseYDragInit = 0;
  double mouseYDragEnd = 0;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!widget.animated) {
        return;
      }
      if (focusNode.hasFocus) {
        setState(() {
          hasFocus = true;
        });
      } else {
        setState(() {
          hasFocus = false;
        });
      }
    });
  }

  double getBottomMargin() {
    if (hasFocus || controller.text.isNotEmpty) {
      return (widget.height ?? 50) - 12;
    }
    return ((((widget.height ?? 50) - 20) / 2)) + (widget.labelOffse?.dy ?? 0);
  }

  double getLeftMargin() {
    return 0;
  }

  TextInputType getInputType() {
    switch (keyboardType) {
      case LukyTextInputType.text:
        return TextInputType.text;
      case LukyTextInputType.number:
        return TextInputType.number;
      case LukyTextInputType.email:
        return TextInputType.emailAddress;
      case LukyTextInputType.password:
        return TextInputType.visiblePassword;
      case LukyTextInputType.phone:
        return TextInputType.phone;
      case LukyTextInputType.url:
        return TextInputType.url;
      case LukyTextInputType.date:
        return TextInputType.datetime;
      case LukyTextInputType.time:
        return TextInputType.datetime;
      case LukyTextInputType.datetime:
        return TextInputType.datetime;
      case LukyTextInputType.search:
        return TextInputType.text;
      case LukyTextInputType.integer:
        return TextInputType.numberWithOptions(decimal: false);
      case LukyTextInputType.decimal:
        return TextInputType.numberWithOptions(decimal: true);
    }
  }

  List<TextInputFormatter>? getInputFormatters() {
    switch (keyboardType) {
      case LukyTextInputType.text:
        return null;
      case LukyTextInputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  Widget? gePasswordToggleButton(BuildContext context) {
    final theme = Luky.of(context).theme;
    if (keyboardType == LukyTextInputType.password ||
        controller is LukyPaswordEdittingController) {
      final c = (controller as LukyPaswordEdittingController);
      return IconButton(
        icon: Icon(
          c.isObscure ? Icons.no_encryption_outlined : Icons.lock_open_rounded,
          color: widget.foregroundColor ?? theme.colorScheme.onSurface,
        ),
        onPressed: () {
          setState(() {
            c.toggleObscure();
          });
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    late final height = widget.height ?? 50;
    final borderRadius =
        BorderRadius.circular(getSize(LukySize.md, context) ?? 10);
    final theme = Luky.of(context).theme;
    inputBorder = widget.inputBorder ??
        OutlineInputBorder(
          borderRadius: widget.borderRadius ?? borderRadius,
          borderSide: BorderSide(
            color: widget.borderColor ?? theme.colorScheme.primary,
            width: widget.borderWidth ?? 2.0,
          ),
        );

    final cannotCalculate = (!widget.enableValueDrag ||
        widget.inputType != LukyTextInputType.number &&
            widget.inputType != LukyTextInputType.decimal &&
            widget.inputType != LukyTextInputType.integer);

    return GestureDetector(
      onHorizontalDragUpdate: cannotCalculate
          ? null
          : (details) {
              if (focusNode.hasFocus == true) {
                return;
              }
              final isDecimal = widget.inputType == LukyTextInputType.decimal ||
                  widget.inputType == LukyTextInputType.number;
              final val =
                  controller.text.isEmpty ? 0.0 : double.parse(controller.text);
              if ((mouseYDragInit > details.localPosition.dx)) {
                controller.text = (val - widget.dragValueFactor)
                    .toStringAsFixed(isDecimal ? 2 : 0);
              } else {
                controller.text = (val + widget.dragValueFactor)
                    .toStringAsFixed(isDecimal ? 2 : 0);
              }
              mouseYDragInit = details.localPosition.dx;
            },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            color: widget.debug == true ? Colors.red : null,
            height: height + 20,
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text("Name:"),
                LukyCard(
                  boxShadow: widget.boxShadow ?? LukyShadow.basic, //SHADOW
                  padding: 0,
                  spacing: 0,
                  width: widget.width,
                  height: height,
                  borderRadius: borderRadius,

                  bodyContentWidget: SizedBox(
                    width: double.infinity,
                    height: height,
                    child: TextFormField(
                      keyboardType: getInputType(),
                      inputFormatters: getInputFormatters(),
                      focusNode: focusNode,
                      controller: controller,
                      style: widget.textStyle ??
                          TextStyle(
                            color: widget.foregroundColor ??
                                theme.colorScheme.onSurface,
                          ),
                      expands: true,
                      maxLength: null,
                      obscureText: false,
                      maxLines: null,
                      decoration: widget.inputDecoration ??
                          InputDecoration(
                            enabledBorder: inputBorder,
                            focusedBorder: widget.focusedBorder,
                            disabledBorder: widget.disabledBorder,
                            focusedErrorBorder: widget.focusedErrorBorder,
                            fillColor: widget.foregroundColor,
                            errorBorder: widget.errorBorder,
                            hintText: !hasFocus ? null : widget.hint,
                            prefixIcon: widget.startChild,
                            suffixIcon: widget.endChild ??
                                gePasswordToggleButton(context),
                            contentPadding: widget.contentPadding ??
                                EdgeInsets.only(
                                  top: (inputBorder.borderSide.width == 0
                                      ? (widget.hint != null ? 16 : 22)
                                      : 0),
                                  left: 10,
                                  right: 10,
                                  bottom: 10,
                                ),
                            border: inputBorder,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.label != null || widget.labelText != null)
            IgnorePointer(
              ignoring: !hasFocus,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(
                    left: hasFocus
                        ? (widget.animatedLabelOffse?.dx ?? 0)
                        : (widget.labelOffse?.dx ?? 10),
                    bottom: getBottomMargin()),
                child: widget.label ??
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      decoration: widget.labelDecoration ??
                          BoxDecoration(
                              boxShadow: widget.labelShadow,
                              color: widget.backgroundColor ??
                                  theme.colorScheme.surface,
                              borderRadius: widget.borderRadius ?? borderRadius,
                              border: (inputBorder.borderSide.width > 0)
                                  ? Border.all(
                                      color: (widget.borderColor ??
                                              widget.foregroundColor ??
                                              theme.colorScheme.primary)
                                          .withAlpha(hasFocus ? 250 : 0),
                                      width: (widget.borderWidth ??
                                          inputBorder.borderSide.width),
                                    )
                                  : null),
                      child: Text(
                        widget.labelText!,
                        style: widget.labelStyle ??
                            TextStyle(
                              color: widget.foregroundColor ??
                                  theme.colorScheme.secondary,
                            ),
                      ),
                    ),
              ),
            )
        ],
      ),
    );
  }
}
