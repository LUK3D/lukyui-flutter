import 'package:flutter/material.dart';

///## LukyFadeoutMask
/// A widget that applies a fade-out mask to its child using a gradient.
/// The mask can be customized with either a gradient or a list of colors and stops.
///
///[child]: The widget to which the fade-out mask will be applied.
///
///[gradient]: The gradient to use for the fade-out mask. If provided, colors and stops should be null.
///
///[colors]: A list of colors to use for the fade-out mask. If provided, gradient should be null.
///
///[stops]: A list of stops corresponding to the colors. Must be provided if colors are provided.
////
class LukyFadeoutMask extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final List<Color>? colors;
  final List<double>? stops;
  const LukyFadeoutMask({
    super.key,
    required this.child,
    this.gradient,
    this.colors,
    this.stops,
  }) : assert(
          (gradient != null && colors == null && stops == null ||
                  gradient == null && colors == null && stops == null) ||
              (gradient == null && colors != null && stops != null),
          'Either gradient or colors and stops must be provided, not both.',
        );

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return (gradient ??
                LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors ??
                      const [
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                  stops: stops,
                ))
            .createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
