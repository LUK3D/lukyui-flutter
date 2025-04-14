import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';

class LukyUserAvatar<T> extends StatelessWidget {
  final T? data;
  final String? imageUrl;
  final String? name;
  final Function(T? data)? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? offsetColor;
  final double? offsetWidth;
  final Color? borderColor;
  final double? borderWidth;
  final Color? ringColor;
  final double? ringWidth;
  final double size;
  final BorderRadius? borderRadius;
  final Widget? errorFallbackWidget;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget? icon;
  const LukyUserAvatar({
    super.key,
    this.data,
    this.imageUrl,
    this.name,
    this.onTap,
    this.offsetColor,
    this.offsetWidth,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.ringColor = Colors.transparent,
    this.ringWidth,
    this.size = 40,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.errorFallbackWidget,
    this.loadingBuilder,
    this.icon,
  });

  Widget getChild(BuildContext context) {
    final theme = Luky.of(context).theme;

    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (errorFallbackWidget == null)
            ? null
            : (context, error, stackTrace) {
                return errorFallbackWidget!;
              },
        loadingBuilder: loadingBuilder,
      );
    }

    if (name != null && name!.isNotEmpty) {
      return Center(
        child: Text(
          name!,
          style: TextStyle(
              color: textColor ?? theme.colorScheme.onSurface,
              fontSize: getSize(LukySize.xs, context)),
          overflow: TextOverflow.clip,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      );
    }

    return icon ??
        Icon(
          Icons.person,
          size: 24,
          color: theme.colorScheme.onSurface,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all((borderWidth ?? 4) + (offsetWidth ?? 0)),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: borderColor ?? theme.colorScheme.primary,
            borderRadius:
                scaleBorderRadius(borderRadius, (offsetWidth ?? 1) * 1.5) ??
                    BorderRadius.circular(100),
            border: Border.all(
              color: ringColor ?? theme.colorScheme.background,
              strokeAlign: -1,
              width: ringWidth ?? 2,
            ),
          ),
          child: Container(
            width: size,
            height: size,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: backgroundColor ?? theme.colorScheme.surface,
              borderRadius: scaleBorderRadius(borderRadius, offsetWidth ?? 1) ??
                  BorderRadius.circular(100),
              border: Border.all(
                color: offsetColor ?? theme.colorScheme.background,
                strokeAlign: 1,
                width: offsetWidth ?? 2,
              ),
            ),
            child: getChild(context),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: SizedBox(
            width: size,
            height: size,
            child: Material(
              borderRadius: scaleBorderRadius(borderRadius, offsetWidth ?? 1) ??
                  BorderRadius.circular(100),
              color: Colors.transparent,
              child: InkWell(
                borderRadius:
                    scaleBorderRadius(borderRadius, offsetWidth ?? 1) ??
                        BorderRadius.circular(100),
                onTap: onTap == null
                    ? null
                    : () {
                        onTap?.call(data);
                      },
                splashColor:
                    (borderColor ?? theme.colorScheme.primary).withAlpha(50),
              ),
            ),
          ),
        )
      ],
    );
  }
}
