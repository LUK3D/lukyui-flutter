import 'package:flutter/material.dart';

typedef LukyDotBuilder = Widget Function(
  int index,
  Offset position,
  double radius,
);

class LukyDottedGrid extends StatelessWidget {
  final double dotRadius;
  final Color dotColor;
  final double spacing;
  final LukyDotBuilder? builder;
  final Color? backgroundColor;

  const LukyDottedGrid({
    super.key,
    this.dotRadius = 4,
    this.dotColor = Colors.grey,
    this.spacing = 12,
    this.builder,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final dx = dotRadius * 2 + spacing;
    final dy = dotRadius * 2 + spacing;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final horizontalCount = (width / dx).floor();
        final verticalCount = (height / dy).floor();

        return Container(
          color: backgroundColor ?? Colors.transparent,
          child: Stack(
            children: [
              CustomPaint(
                size: Size(width, height),
                painter: builder == null
                    ? _DotPainter(
                        horizontalCount: horizontalCount,
                        verticalCount: verticalCount,
                        dotRadius: dotRadius,
                        color: dotColor,
                        spacing: spacing,
                      )
                    : null,
              ),
              if (builder != null)
                ..._buildDotWidgets(
                    width, height, horizontalCount, verticalCount),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDotWidgets(
    double width,
    double height,
    int horizontalCount,
    int verticalCount,
  ) {
    final List<Widget> widgets = [];
    final dx = dotRadius * 2 + spacing;
    final dy = dotRadius * 2 + spacing;

    for (int y = 0; y < verticalCount; y++) {
      for (int x = 0; x < horizontalCount; x++) {
        final index = y * horizontalCount + x;
        final offset = Offset(
          x * dx + dotRadius,
          y * dy + dotRadius,
        );

        widgets.add(Positioned(
          left: offset.dx - dotRadius,
          top: offset.dy - dotRadius,
          width: dotRadius * 2,
          height: dotRadius * 2,
          child: builder!(index, offset, dotRadius),
        ));
      }
    }

    return widgets;
  }
}

class _DotPainter extends CustomPainter {
  final int horizontalCount;
  final int verticalCount;
  final double dotRadius;
  final Color color;
  final double spacing;

  _DotPainter({
    required this.horizontalCount,
    required this.verticalCount,
    required this.dotRadius,
    required this.color,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final dx = dotRadius * 2 + spacing;
    final dy = dotRadius * 2 + spacing;

    for (int y = 0; y < verticalCount; y++) {
      for (int x = 0; x < horizontalCount; x++) {
        final cx = x * dx + dotRadius;
        final cy = y * dy + dotRadius;

        canvas.drawCircle(Offset(cx, cy), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) {
    return oldDelegate.dotRadius != dotRadius ||
        oldDelegate.color != color ||
        oldDelegate.horizontalCount != horizontalCount ||
        oldDelegate.verticalCount != verticalCount ||
        oldDelegate.spacing != spacing;
  }
}
