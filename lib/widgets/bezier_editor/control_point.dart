import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

enum HandleMode {
  free,
  symmetric,
}

class ControlPoint {
  String id = Uuid().v4();
  Offset position;
  Offset? handleIn;
  Offset? handleOut;
  HandleMode handleMode;

  ControlPoint({
    required this.position,
    this.handleIn,
    this.handleOut,
    this.handleMode = HandleMode.free,
  });

  ControlPoint copy() {
    return ControlPoint(
      position: position,
      handleIn: handleIn,
      handleOut: handleOut,
      handleMode: handleMode,
    );
  }

  //from json
  ControlPoint.fromJson(Map<String, dynamic> json)
      : position = Offset(
            json['position'][0].toDouble(), json['position'][1].toDouble()),
        handleIn = json['handleIn'] != null
            ? Offset(
                json['handleIn'][0].toDouble(), json['handleIn'][1].toDouble())
            : null,
        handleOut = json['handleOut'] != null
            ? Offset(json['handleOut'][0].toDouble(),
                json['handleOut'][1].toDouble())
            : null,
        handleMode = HandleMode.values[json['handleMode']],
        id = json['id'] ?? Uuid().v4();

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'handleIn': handleIn,
      'handleOut': handleOut,
      'handleMode': handleMode.index,
    };
  }

  ControlPoint normalized(Size size) {
    final normalized =
        Offset(position.dx / size.width, position.dy / size.height);
    final finalHandleIn = handleIn != null
        ? Offset(handleIn!.dx / size.width, handleIn!.dy / size.height)
        : null;
    final inalHandleOut = handleOut != null
        ? Offset(handleOut!.dx / size.width, handleOut!.dy / size.height)
        : null;
    return ControlPoint(
      position: normalized,
      handleIn: finalHandleIn,
      handleOut: inalHandleOut,
      handleMode: handleMode,
    );
  }
}
