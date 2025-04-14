import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lukyui/widgets/bezier_editor/control_point.dart';

class BezierEditor extends StatefulWidget {
  final List<ControlPoint>? initialValue;
  final void Function(List<ControlPoint> value)? onValueChanged;
  final void Function(ControlPoint? point)? onSelectionChange;
  final bool fixedEndpoints;
  final Color? lineColor;
  final Color? handleColor;
  final Color? smoothnessHandlerColor;
  final Color? selectedHandleColor;

  const BezierEditor(
      {super.key,
      this.fixedEndpoints = true,
      this.initialValue,
      this.onValueChanged,
      this.onSelectionChange,
      this.lineColor,
      this.handleColor,
      this.smoothnessHandlerColor,
      this.selectedHandleColor});

  @override
  State<BezierEditor> createState() => _BezierEditorState();
}

class _BezierEditorState extends State<BezierEditor> {
  List<ControlPoint> controlPoints = [];
  Size? canvasSize;
  int? draggingPointIndex;
  int? selectedIndex;
  String? draggingHandle; // "in" or "out"
  final FocusNode _focusNode = FocusNode();
  bool _modifierHeld = false;
  Offset? _handleGrabOffset;

  void _addControlPoint(Offset position) {
    if (widget.fixedEndpoints) {
      int insertIndex = 1;
      for (int i = 1; i < controlPoints.length; i++) {
        if (position.dx < controlPoints[i].position.dx) {
          insertIndex = i;
          break;
        }
      }
      setState(() {
        controlPoints.insert(insertIndex, ControlPoint(position: position));
        _notifyValueChanged();
      });
    } else {
      setState(() {
        controlPoints.add(ControlPoint(position: position));
        _notifyValueChanged();
      });
    }
  }

  void _setFixedEndpoints(Size size) {
    final h = size.height;
    final w = size.width;

    if (controlPoints.length < 2) {
      controlPoints = [
        ControlPoint(position: Offset(0, h / 2)),
        ControlPoint(position: Offset(w, h / 2)),
      ];
    } else {
      controlPoints[0].position =
          Offset(0, controlPoints[0].position.dy.clamp(0, h));
      controlPoints.last.position =
          Offset(w, controlPoints.last.position.dy.clamp(0, h));
    }
  }

  int? _findHandleIndex(Offset local) {
    for (int i = 0; i < controlPoints.length; i++) {
      final p = controlPoints[i];
      final handleIn = p.handleIn != null ? p.position + p.handleIn! : null;
      final handleOut = p.handleOut != null ? p.position + p.handleOut! : null;

      if (handleIn != null && (handleIn - local).distance < 10) {
        draggingPointIndex = i;
        draggingHandle = "in";
        _handleGrabOffset = handleIn - local;
        return i;
      }

      if (handleOut != null && (handleOut - local).distance < 10) {
        draggingPointIndex = i;
        draggingHandle = "out";
        _handleGrabOffset = handleOut - local;
        return i;
      }
    }
    return null;
  }

  void _notifyValueChanged() {
    if (widget.onValueChanged != null) {
      widget.onValueChanged!(controlPoints.map((e) => e.copy()).toList());
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      controlPoints = widget.initialValue!.map((e) => e.copy()).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      canvasSize = size;

      if (widget.fixedEndpoints) _setFixedEndpoints(size);

      return KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          final isMacOS = Theme.of(context).platform == TargetPlatform.macOS;
          final key = event.logicalKey;

          final isCtrlKey = key == LogicalKeyboardKey.controlLeft ||
              key == LogicalKeyboardKey.controlRight;
          final isCmdKey = key == LogicalKeyboardKey.metaLeft ||
              key == LogicalKeyboardKey.metaRight;

          if (event is KeyDownEvent &&
              ((isMacOS && isCmdKey) || (!isMacOS && isCtrlKey))) {
            setState(() => _modifierHeld = true);
          } else if (event is KeyUpEvent &&
              ((isMacOS && isCmdKey) || (!isMacOS && isCtrlKey))) {
            setState(() => _modifierHeld = false);
          }
        },
        child: GestureDetector(
          onTapUp: (details) {
            final pos = details.localPosition;

            for (int i = 0; i < controlPoints.length; i++) {
              if ((controlPoints[i].position - pos).distance < 12) {
                if (_modifierHeld) {
                  if (widget.fixedEndpoints &&
                      (i == 0 || i == controlPoints.length - 1)) {
                    return;
                  }
                  setState(() {
                    debugPrint('Removed control point at index $i');
                    controlPoints.removeAt(i);
                    selectedIndex = null;
                    _notifyValueChanged();
                  });
                  return;
                } else {
                  setState(() {
                    selectedIndex = i;
                    if (controlPoints[i].handleIn == null) {
                      controlPoints[i].handleIn = Offset(-30, 0);
                    }
                    if (controlPoints[i].handleOut == null) {
                      controlPoints[i].handleOut = Offset(30, 0);
                    }
                    widget.onSelectionChange?.call(controlPoints[i]);
                  });
                  return;
                }
              }
            }

            // Else: add new point
            _addControlPoint(pos);
            selectedIndex = null;
            widget.onSelectionChange?.call(null);
          },
          onDoubleTapDown: (details) {
            final tapPos = details.localPosition;

            for (int i = 0; i < controlPoints.length; i++) {
              if ((controlPoints[i].position - tapPos).distance < 12) {
                setState(() {
                  final point = controlPoints[i];
                  if (point.handleMode == HandleMode.free) {
                    point.handleMode = HandleMode.symmetric;

                    // If one handle exists, mirror it
                    if (point.handleIn != null) {
                      point.handleOut = -point.handleIn!;
                    } else if (point.handleOut != null) {
                      point.handleIn = -point.handleOut!;
                    } else {
                      point.handleOut = const Offset(30, 0);
                      point.handleIn = const Offset(-30, 0);
                    }
                  } else {
                    point.handleMode = HandleMode.free;
                    // Make the handles independent by keeping current positions
                    // No changes needed unless you want to reset one to zero
                  }
                });
                break;
              }
            }
          },
          onPanStart: (details) {
            final pos = details.localPosition;
            // Check if handle drag
            if (_findHandleIndex(pos) != null) return;

            for (int i = 0; i < controlPoints.length; i++) {
              if ((controlPoints[i].position - pos).distance < 12) {
                draggingPointIndex = i;
                return;
              }
            }
          },
          onPanUpdate: (details) {
            if (draggingPointIndex != null && canvasSize != null) {
              final i = draggingPointIndex!;
              final delta = details.delta;
              final cp = controlPoints[i];

              if (draggingHandle != null && _handleGrabOffset != null) {
                final handlePos = details.localPosition + _handleGrabOffset!;
                final relative = handlePos - cp.position;

                setState(() {
                  if (draggingHandle == "in") {
                    cp.handleIn = relative;
                    if (cp.handleMode == HandleMode.symmetric) {
                      cp.handleOut = -relative;
                    }
                  } else {
                    cp.handleOut = relative;
                    if (cp.handleMode == HandleMode.symmetric) {
                      cp.handleIn = -relative;
                    }
                  }
                });
              } else {
                // Main point dragging
                Offset updated = cp.position + delta;
                double newX = updated.dx.clamp(0.0, canvasSize!.width);
                double newY = updated.dy.clamp(0.0, canvasSize!.height);

                setState(() {
                  if (widget.fixedEndpoints) {
                    if (i == 0) {
                      cp.position = Offset(0, newY);
                    } else if (i == controlPoints.length - 1) {
                      cp.position = Offset(canvasSize!.width, newY);
                    } else {
                      cp.position = Offset(newX, newY);
                    }
                  } else {
                    cp.position = Offset(newX, newY);
                  }
                });
              }
            }
            _notifyValueChanged();
          },
          onPanEnd: (_) {
            draggingHandle = null;
            _handleGrabOffset = null;
          },
          child: RepaintBoundary(
            child: CustomPaint(
              size: size,
              painter: BezierPainter(
                  points: controlPoints,
                  selectedIndex: selectedIndex,
                  lineColor: widget.lineColor,
                  handleColor: widget.handleColor,
                  smoothnessHandlerColor: widget.smoothnessHandlerColor,
                  selectedHandleColor: widget.selectedHandleColor),
            ),
          ),
        ),
      );
    });
  }
}

class BezierPainter extends CustomPainter {
  final List<ControlPoint> points;
  final int? selectedIndex;
  final Color? lineColor;
  final Color? handleColor;
  final Color? smoothnessHandlerColor;
  final Color? selectedHandleColor;

  BezierPainter({
    required this.points,
    this.selectedIndex,
    this.lineColor,
    this.handleColor,
    this.smoothnessHandlerColor,
    this.selectedHandleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor ?? Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final handlePaint = Paint()
      ..color = smoothnessHandlerColor ?? Colors.orange
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final path = Path();
    if (points.length > 1) {
      path.moveTo(points[0].position.dx, points[0].position.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p1 = points[i];
        final p2 = points[i + 1];
        final cp1 =
            p1.handleOut != null ? p1.position + p1.handleOut! : p1.position;
        final cp2 =
            p2.handleIn != null ? p2.position + p2.handleIn! : p2.position;
        path.cubicTo(
            cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.position.dx, p2.position.dy);
      }

      canvas.drawPath(path, paint);
    }

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final isSelected = i == selectedIndex;
      if (isSelected) {
        if (p.handleIn != null) {
          if (points[i].handleIn != null) {
            final start = points[i].position;
            final end = start + points[i].handleIn!;
            canvas.drawLine(start, end, handlePaint);
            canvas.drawCircle(end, 5, handlePaint);
          }
        }

        if (p.handleOut != null) {
          final start = points[i].position;
          final end = start + points[i].handleOut!;
          canvas.drawLine(start, end, handlePaint);
          canvas.drawCircle(end, 5, handlePaint);
        }
      }
      Paint pointPaint = Paint()
        ..color = isSelected
            ? selectedHandleColor ?? Colors.green
            : handleColor ?? Colors.blue
        ..style = PaintingStyle.fill;

      canvas.drawCircle(p.position, 6, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant BezierPainter oldDelegate) => true;
}
