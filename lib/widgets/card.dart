import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';
import 'package:lukyui/utils/utils.dart';
import '../utils/shadow.dart';

class LukyCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final Color? backgroundColor;
  final Widget? headerWidget;
  final Widget? headerStartChild;
  final Widget? headerEndChild;
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final String? bodyContent;
  final Widget? bodyContentWidget;
  final String? footerContent;
  final Widget? footerContentWidget;
  final double? imageHeight;
  final double? imageWidth;
  final double? spacing;
  final String? imageUrl;
  final Widget? imageWidget;
  final String? avatarImageUrl;
  final Widget? avatarWidget;
  final bool? showHeaderDivider;
  final bool? showBodyDivider;
  final BorderRadius? borderRadius;
  final BorderRadius? imageBorderRadius;
  final BorderRadius? avatarBorderRadius;
  final Color? dividerColor;
  final List<BoxShadow>? boxShadow;
  final double? padding;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? bodyContentStyle;
  final TextStyle? footerContentStyle;
  final BoxBorder? border;

  const LukyCard({
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.headerStartChild,
    this.headerEndChild,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.bodyContent,
    this.bodyContentWidget,
    this.footerContent,
    this.footerContentWidget,
    this.imageUrl,
    this.imageHeight,
    this.imageWidth,
    this.imageWidget,
    this.avatarImageUrl,
    this.avatarWidget,
    this.headerWidget,
    this.showHeaderDivider,
    this.showBodyDivider,
    this.borderRadius,
    this.imageBorderRadius,
    this.avatarBorderRadius,
    this.dividerColor,
    this.boxShadow,
    this.padding,
    this.titleStyle,
    this.subtitleStyle,
    this.bodyContentStyle,
    this.footerContentStyle,
    this.border,
    this.spacing,
    this.minWidth,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Luky.of(context).theme;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width ?? 400,
        maxHeight: height ?? double.infinity,
        minWidth: width ?? 400,
        minHeight: height ?? 0,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: padding ?? getSize(LukySize.lg, context) ?? 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
          boxShadow: boxShadow ?? LukyShadow.xl,
          border: border,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: spacing ?? 8,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: padding ?? getSize(LukySize.lg, context) ?? 16),
              child: (headerWidget != null)
                  ? headerWidget!
                  : Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: spacing ?? 8,
                      children: [
                        Row(
                          spacing: spacing ?? 8,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (headerStartChild != null)
                                ? headerStartChild!
                                : ((avatarImageUrl != null ||
                                        avatarWidget != null)
                                    ? LukyUserAvatar(
                                        backgroundColor:
                                            theme.colorScheme.dividerColor,
                                        borderRadius: BorderRadius.circular(5),
                                        size: 40,
                                        offsetWidth: 2,
                                        imageUrl: avatarImageUrl,
                                        icon: avatarWidget,
                                      )
                                    : SizedBox.shrink()),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (title != null)
                                  Text(
                                    title!,
                                    style: titleStyle ??
                                        TextStyle(
                                          fontSize: theme.fontSize.textLg,
                                          fontWeight: FontWeight.w500,
                                          color: theme.colorScheme.onSurface,
                                          height: 1,
                                        ),
                                  ),
                                if (titleWidget != null) titleWidget!,
                                if (subtitle != null)
                                  Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      subtitle!,
                                      style: subtitleStyle ??
                                          TextStyle(
                                            height: 1,
                                            fontSize: theme.fontSize.textXs,
                                            fontWeight: FontWeight.w500,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (headerEndChild != null) headerEndChild!,
                      ],
                    ),
            ),
            if ((headerWidget != null ||
                    title != null ||
                    subtitle != null ||
                    titleWidget != null) &&
                showHeaderDivider == true)
              Divider(
                height: 1,
                color: theme.colorScheme.dividerColor,
              ),
            if (bodyContent != null || bodyContentWidget != null)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding ?? getSize(LukySize.lg, context) ?? 16),
                child: (bodyContent != null)
                    ? Text(
                        bodyContent!,
                        style: bodyContentStyle ??
                            TextStyle(
                              fontSize: theme.fontSize.textSm,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                      )
                    : bodyContentWidget,
              ),
            if (imageUrl != null || imageWidget != null)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding ?? getSize(LukySize.lg, context) ?? 16),
                child: (imageWidget != null)
                    ? imageWidget!
                    : Container(
                        clipBehavior: Clip.antiAlias,
                        height: imageHeight,
                        width: imageWidth ?? double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: imageBorderRadius ??
                              BorderRadius.circular(
                                  getSize(LukySize.sm, context) ?? 10),
                        ),
                        child: Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            if ((bodyContent != null ||
                    bodyContentWidget != null ||
                    imageUrl != null ||
                    imageWidget != null) &&
                showBodyDivider == true)
              Divider(
                height: 1,
                color: theme.colorScheme.dividerColor,
              ),
            if (footerContent != null || footerContentWidget != null)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: padding ?? getSize(LukySize.lg, context) ?? 16),
                child: (footerContentWidget != null)
                    ? footerContentWidget!
                    : Text(footerContent!,
                        style: footerContentStyle ??
                            TextStyle(
                              fontSize: theme.fontSize.textSm,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            )),
              ),
          ],
        ),
      ),
    );
  }
}
