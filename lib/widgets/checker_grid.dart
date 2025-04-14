import 'package:flutter/material.dart';

class LukyCheckerGrid extends StatelessWidget {
  final int horizontalLines;
  final int verticalLines;
  final Color color1;
  final Color color2;
  final Widget Function(int x, int y, Color color, Rect rect)? cellBuilder;

  const LukyCheckerGrid({
    super.key,
    required this.horizontalLines,
    required this.verticalLines,
    this.color1 = Colors.white,
    this.color2 = Colors.grey,
    this.cellBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final cellWidth = constraints.maxWidth / verticalLines;
        final cellHeight = constraints.maxHeight / horizontalLines;

        final overlays = <Widget>[];

        if (cellBuilder != null) {
          for (int y = 0; y < horizontalLines; y++) {
            for (int x = 0; x < verticalLines; x++) {
              final isEven = (x + y) % 2 == 0;
              final color = isEven ? color1 : color2;

              final rect = Rect.fromLTWH(
                x * cellWidth,
                y * cellHeight,
                cellWidth,
                cellHeight,
              );

              overlays.add(Positioned.fromRect(
                rect: rect,
                child: cellBuilder!(x, y, color, rect),
              ));
            }
          }
        }

        return Stack(
          children: [
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _LukyCheckerGridPainter(
                horizontalLines,
                verticalLines,
                color1,
                color2,
              ),
            ),
            ...overlays,
          ],
        );
      },
    );
  }
}

class _LukyCheckerGridPainter extends CustomPainter {
  final int rows;
  final int cols;
  final Color color1;
  final Color color2;

  _LukyCheckerGridPainter(this.rows, this.cols, this.color1, this.color2);

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;
    final paint = Paint();

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        paint.color = (x + y) % 2 == 0 ? color1 : color2;
        canvas.drawRect(
          Rect.fromLTWH(x * cellWidth, y * cellHeight, cellWidth, cellHeight),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
