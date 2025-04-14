import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

class LukyCheckbox extends StatefulWidget {
  final double width;
  final double height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Color? activeBorderColor;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? iconColor;
  final Color? activeIconColor;
  final Widget? icon;
  final bool isChecked;
  final Function(bool value)? onChanged;
  final Duration? duration;
  final Curve? curve;
  final bool? isDisabled;
  const LukyCheckbox({
    super.key,
    this.width = 35,
    this.height = 35,
    this.padding = const EdgeInsets.all(0),
    this.borderRadius,
    this.borderColor,
    this.backgroundColor,
    this.activeColor,
    this.iconColor,
    this.activeIconColor,
    this.icon,
    this.isChecked = false,
    this.onChanged,
    this.activeBorderColor,
    this.borderWidth = 3,
    this.duration,
    this.curve,
    this.isDisabled,
  });

  @override
  State<LukyCheckbox> createState() => _LukyCheckboxState();
}

class _LukyCheckboxState extends State<LukyCheckbox> {
  double _width = 0;
  double _height = 0;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
    if (widget.isChecked) {
      _width = widget.width;
      _height = widget.height;
    }
  }

  void _toggleSize() {
    setState(() {
      _width = _width == 0 ? widget.width : 0;
      _height = _height == 0 ? widget.height : 0;
      _isChecked = !_isChecked;
    });
    widget.onChanged?.call(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return LukyButton(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      borderWidth: widget.borderWidth ?? 4,
      foregroundColor: widget.activeColor ?? theme.colorScheme.primary,
      borderColor: _isChecked
          ? (widget.activeBorderColor ??
              (widget.borderColor ?? theme.colorScheme.surface))
          : (widget.borderColor ?? theme.colorScheme.surface),
      variant: LukyButtonVariant.bordered,
      borderRadius: widget.borderRadius ??
          BorderRadius.circular(getSize(LukySize.xs, context) ?? 12),
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(0),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.dividerColor,
      onPressed: widget.isDisabled == true ? null : _toggleSize,
      child: Transform.scale(
        scale: 1,
        child: AnimatedContainer(
          width: clampDouble(
              _width, 0, (widget.width * 0.69) * (widget.borderWidth ?? 1)),
          height: clampDouble(
              _height, 0, (widget.height * 0.69) * (widget.borderWidth ?? 1)),
          duration: widget.duration ?? const Duration(milliseconds: 300),
          curve: widget.curve ?? Curves.easeInOut,
          alignment: Alignment.center,
          // color: Colors.blue,
          decoration: BoxDecoration(borderRadius: widget.borderRadius),
          child: Container(
            width: widget.width - 5,
            height: widget.height - 5,
            clipBehavior: Clip.antiAlias,
            margin: widget.padding ?? EdgeInsets.all(widget.width * 0.2),
            decoration: BoxDecoration(
              color: widget.activeColor ?? theme.colorScheme.primary,
            ),
            child: (widget.icon != null)
                ? widget.icon
                : Icon(
                    Icons.check,
                    color: _isChecked
                        ? (widget.activeIconColor ??
                            (widget.iconColor ?? theme.colorScheme.onPrimary))
                        : (widget.iconColor ?? theme.colorScheme.onPrimary),
                  ),
          ),
        ),
      ),
    );
  }
}
