import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lukyui/lukyui_components.dart';

class Luky2DGrid extends StatefulWidget {
  final Color lineColor;
  final double strokeWidth;
  final bool showBorder;
  final double? horizontalLines;
  final double? verticalLines;
  final double minScale;
  final double maxScale;

  const Luky2DGrid({
    super.key,
    this.horizontalLines,
    this.verticalLines,
    this.lineColor = Colors.grey,
    this.strokeWidth = 1.0,
    this.showBorder = false,
    this.minScale = 0.2,
    this.maxScale = 4.0,
  });

  @override
  State<Luky2DGrid> createState() => _Luky2DGridState();
}

class _Luky2DGridState extends State<Luky2DGrid> {
  double scale = 1.0;
  bool isZooming = false;
  final scrollController = LukyScrollController();

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      final keys = HardwareKeyboard.instance.logicalKeysPressed;

      final isZoomGesture = keys.contains(LogicalKeyboardKey.controlLeft) ||
          keys.contains(LogicalKeyboardKey.controlRight) ||
          keys.contains(LogicalKeyboardKey.metaLeft) ||
          keys.contains(LogicalKeyboardKey.metaRight);

      if (isZoomGesture) {
        setState(() {
          isZooming = true; // Start zooming
          final delta = event.scrollDelta.dy;
          final factor = delta > 0 ? 0.9 : 1.1;
          scale = (scale * factor).clamp(widget.minScale, widget.maxScale);
        });
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        LukyScrollsManager().blockScrolls(scrollController.id);
      },
      onExit: (event) {
        LukyScrollsManager().unblockScrolls(scrollController.id);
      },
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        behavior: HitTestBehavior.opaque,
        child: CustomPaint(
          size: Size.infinite,
          painter: _GridPainter(
            horizontalLines: widget.horizontalLines != null
                ? widget.horizontalLines! * scale
                : null,
            verticalLines: widget.verticalLines != null
                ? widget.verticalLines! * scale
                : null,
            color: widget.lineColor,
            strokeWidth: widget.strokeWidth,
            showBorder: widget.showBorder,
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double? horizontalLines;
  final double? verticalLines;
  final Color color;
  final double strokeWidth;
  final bool showBorder;

  _GridPainter({
    required this.horizontalLines,
    required this.verticalLines,
    required this.color,
    required this.strokeWidth,
    required this.showBorder,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width.isInfinite || size.height.isInfinite) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    final lines = <Offset>[];

    // Determine vertical line positions
    if (verticalLines != null) {
      for (double x = 0; x <= size.width; x += verticalLines!) {
        if (!showBorder && (x == 0 || x >= size.width)) continue;
        lines.add(Offset(x, 0));
        lines.add(Offset(x, size.height));
      }
    }

    // Determine horizontal line positions
    if (horizontalLines != null) {
      for (double y = 0; y <= size.height; y += horizontalLines!) {
        if (!showBorder && (y == 0 || y >= size.height)) continue;
        lines.add(Offset(0, y));
        lines.add(Offset(size.width, y));
      }
    }

    // Draw all lines
    for (int i = 0; i < lines.length; i += 2) {
      canvas.drawLine(lines[i], lines[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
