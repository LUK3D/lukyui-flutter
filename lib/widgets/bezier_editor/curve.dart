import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'control_point.dart';

/// ## LukyBezierToCurve
/// Convers LukyBezierCurve to Flutter's [Curve] class
/// that uses a series of cubic Bézier segments to define the curve shape.
class LukyBezierToCurve extends Curve {
  /// A list of [ControlPoint]s defining the curve.
  /// These must be sorted by their `position.dx` in ascending order,
  /// and must include at least two points (start and end).
  final List<ControlPoint> points;

  LukyBezierToCurve(this.points) {
    assert(points.length >= 2, 'At least two points are required');
  }

  @override
  double transform(double t) {
    // Bail early if there are not enough points to form a curve
    if (points.length < 2) return t;

    if (t <= 0.0) return 0.0;
    if (t >= 1.0) return 1.0;

    // Clamp `t` to a valid range between 0 and 1
    t = t.clamp(0.0, 1.0);

    // Loop through pairs of control points to find the segment
    // that the input `t` falls within (based on x-axis)
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // If `t` lies between p0.dx and p1.dx, it's within this segment
      if (t >= p0.position.dx && t <= p1.position.dx) {
        // Normalize `t` within this segment's local range
        final segmentT =
            (t - p0.position.dx) / (p1.position.dx - p0.position.dx);

        // Compute the cubic Bézier control points
        final cp1 = p0.position + (p0.handleOut ?? Offset.zero);
        final cp2 = p1.position + (p1.handleIn ?? Offset.zero);

        // Compute the curve point using cubic Bézier interpolation
        final result =
            _cubicBezier(p0.position, cp1, cp2, p1.position, segmentT);

        // Return the y-value (dy) of the result as the curve's output
        return result.dy;
      }
    }

    // Fallback: if `t` is outside all segments (shouldn't happen if [0,1]),
    // return the y-value of the last point
    return points.last.position.dy;
  }

  /// Cubic Bézier interpolation using the standard formula:
  ///
  /// ```dart
  ///B(t) = (1 - t)^3 * P0 +
  ///3 * (1 - t)^2 * t * CP1 +
  ///3 * (1 - t) * t^2 * CP2 +
  ///t^3 * P1
  /// ```
  Offset _cubicBezier(Offset p0, Offset cp1, Offset cp2, Offset p1, double t) {
    final u = 1 - t;

    return (p0 * (u * u * u)) +
        (cp1 * (3 * u * u * t)) +
        (cp2 * (3 * u * t * t)) +
        (p1 * (t * t * t));
  }
}
