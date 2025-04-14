import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LineBetweenPointsPage extends StatefulWidget {
  final double? smoothness;
  final bool? animate;

  const LineBetweenPointsPage({super.key, this.smoothness, this.animate});

  @override
  State<LineBetweenPointsPage> createState() => _LineBetweenPointsPageState();
}

class _LineBetweenPointsPageState extends State<LineBetweenPointsPage> {
  final GlobalKey pointAKey = GlobalKey();
  final GlobalKey pointBKey = GlobalKey();
  final GlobalKey pointCKey = GlobalKey();

  Offset pointAPosition = const Offset(100, 100);
  Offset pointBPosition = const Offset(200, 300);
  Offset pointCPosition = const Offset(200, 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Line Between Points')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Draw the line between points using a CustomPainter.
              Positioned.fill(
                child: AnimatedLine(
                  getLinePoints: () =>
                      [pointAPosition, pointBPosition, pointCPosition],
                  smoothness: widget.smoothness ?? widget.smoothness ?? 0.0,
                  isDashed: true,
                  dashRadius: 2,
                  dashGap: 10,
                  dashLength: 12,
                  strokeWidth: 4.0,
                  // color: Colors.orange,
                  gradient:
                      LinearGradient(colors: [Colors.amber, Colors.purple]),
                  animate: widget.animate == true,
                  animationSpeed: 20, // pixels per second
                  flowDirection: AxisDirection.right,
                ),
              ),
              Positioned.fill(
                child: AnimatedLine(
                  getLinePoints: () => [pointAPosition, pointCPosition],
                  smoothness: widget.smoothness ?? widget.smoothness ?? 0.0,
                  isDashed: true,
                  dashRadius: 2,
                  dashGap: 10,
                  dashLength: 12,
                  strokeWidth: 4.0,
                  // color: Colors.orange,
                  gradient:
                      LinearGradient(colors: [Colors.amber, Colors.purple]),
                  animate: widget.animate == true,
                  animationSpeed: 20, // pixels per second
                  flowDirection: AxisDirection.right,
                ),
              ),

              // Point A
              Positioned(
                left: pointAPosition.dx - 25,
                top: pointAPosition.dy - 25,
                child: DraggablePoint(
                  key: pointAKey,
                  initialPosition: pointAPosition,
                  color: Colors.red,
                  onPositionChanged: (pos) {
                    setState(() {
                      pointAPosition = pos;
                    });
                  },
                ),
              ),

              // Point B
              Positioned(
                left: pointBPosition.dx - 25,
                top: pointBPosition.dy - 25,
                child: DraggablePoint(
                  key: pointBKey,
                  initialPosition: pointBPosition,
                  color: Colors.blue,
                  onPositionChanged: (pos) {
                    setState(() {
                      pointBPosition = pos;
                    });
                  },
                ),
              ),

              // Point C
              Positioned(
                left: pointCPosition.dx - 25,
                top: pointCPosition.dy - 25,
                child: DraggablePoint(
                  key: pointCKey,
                  initialPosition: pointCPosition,
                  color: Colors.green,
                  onPositionChanged: (pos) {
                    setState(() {
                      pointCPosition = pos;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Reusable draggable point widget
class DraggablePoint extends StatefulWidget {
  final Offset initialPosition;
  final Color color;
  final ValueChanged<Offset> onPositionChanged;

  const DraggablePoint({
    super.key,
    required this.initialPosition,
    required this.color,
    required this.onPositionChanged,
  });

  @override
  State<DraggablePoint> createState() => _DraggablePointState();
}

class _DraggablePointState extends State<DraggablePoint> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  void _updatePosition(DragUpdateDetails details) {
    setState(() {
      position += details.delta;
      widget.onPositionChanged(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _updatePosition,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class AnimatedLine extends StatefulWidget {
  final List<Offset> Function() getLinePoints;
  final double smoothness;
  final bool isDashed;
  final double dashLength;
  final double dashGap;
  final double dashRadius;
  final double strokeWidth;
  final Color color;
  final Gradient? gradient;
  final bool animate;
  final double animationSpeed;
  final AxisDirection flowDirection;

  const AnimatedLine({
    super.key,
    required this.getLinePoints,
    this.smoothness = 0.0,
    this.isDashed = false,
    this.dashLength = 8.0,
    this.dashGap = 4.0,
    this.dashRadius = 0.0,
    this.strokeWidth = 2.0,
    this.color = Colors.black,
    this.gradient,
    this.animate = false,
    this.animationSpeed = 40.0,
    this.flowDirection = AxisDirection.right,
  });

  @override
  State<AnimatedLine> createState() => _AnimatedLineState();
}

class _AnimatedLineState extends State<AnimatedLine>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _dashOffset = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _ticker = createTicker(_onTick)..start();
    } else {
      _ticker = createTicker((_) {});
    }
  }

  void _onTick(Duration elapsed) {
    final delta = widget.animationSpeed / 60.0; // approx per frame
    setState(() {
      _dashOffset +=
          (widget.flowDirection == AxisDirection.right ? delta : -delta);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LinePainter(
        getLinePoints: widget.getLinePoints,
        smoothness: widget.smoothness,
        isDashed: widget.isDashed,
        dashLength: widget.dashLength,
        dashGap: widget.dashGap,
        dashRadius: widget.dashRadius,
        strokeWidth: widget.strokeWidth,
        color: widget.color,
        gradient: widget.gradient,
        dashOffset: _dashOffset,
      ),
    );
  }
}

// CustomPainter draws the line between the two points.
class LinePainter extends CustomPainter {
  final List<Offset> Function() getLinePoints;
  final double smoothness;
  final bool isDashed;
  final double dashLength;
  final double dashGap;
  final double dashRadius;
  final double strokeWidth;
  final Color color;
  final Gradient? gradient;
  final double dashOffset;

  LinePainter({
    required this.getLinePoints,
    this.smoothness = 0.0,
    this.isDashed = false,
    this.dashLength = 8.0,
    this.dashGap = 4.0,
    this.dashRadius = 0.0,
    this.strokeWidth = 2.0,
    this.color = Colors.black,
    this.gradient,
    required this.dashOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final points = getLinePoints();
    if (points.length < 2) return;

    final start = points[0];
    final end = points[1];
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final radius = smoothness.clamp(0.0, dx.abs() / 2).clamp(0.0, dy.abs() / 2);
    final xDir = dx.sign;
    final yDir = dy.sign;
    final midX = start.dx + dx / 2;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    if (smoothness <= 0.0) {
      path.lineTo(midX, start.dy);
      path.lineTo(midX, end.dy);
      path.lineTo(end.dx, end.dy);
    } else {
      path.lineTo(midX - radius * xDir, start.dy);
      path.quadraticBezierTo(
        midX,
        start.dy,
        midX,
        start.dy + radius * yDir,
      );
      path.lineTo(midX, end.dy - radius * yDir);
      path.quadraticBezierTo(
        midX,
        end.dy,
        midX + radius * xDir,
        end.dy,
      );
      path.lineTo(end.dx, end.dy);
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (gradient != null) {
      final rect = Rect.fromPoints(start, end);
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    if (!isDashed) {
      canvas.drawPath(path, paint);
    } else {
      _drawDashedPath(canvas, path, paint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final PathMetrics metrics = path.computeMetrics();
    for (final PathMetric metric in metrics) {
      double distance = dashOffset % (dashLength + dashGap);
      while (distance < metric.length) {
        final double end = (distance + dashLength).clamp(0.0, metric.length);
        final Path extract = metric.extractPath(distance, end);
        final dashPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = dashRadius > 0 ? StrokeCap.round : StrokeCap.butt
          ..color = paint.color
          ..shader = paint.shader;
        canvas.drawPath(extract, dashPaint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter old) =>
      old.getLinePoints() != getLinePoints() ||
      old.smoothness != smoothness ||
      old.isDashed != isDashed ||
      old.dashLength != dashLength ||
      old.dashGap != dashGap ||
      old.dashRadius != dashRadius ||
      old.strokeWidth != strokeWidth ||
      old.color != color ||
      old.gradient != gradient;
}
