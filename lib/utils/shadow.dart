import 'package:flutter/material.dart';

class LukyShadow {
  static List<BoxShadow> none = [];

  static List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static List<BoxShadow> basic = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static List<BoxShadow> lg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  static List<BoxShadow> xl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: Offset(0, 20),
      blurRadius: 25,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: Offset(0, 10),
      blurRadius: 10,
      spreadRadius: -5,
    ),
  ];

  static final List<BoxShadow> xxl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.25),
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];

  static List<BoxShadow> inner = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      offset: Offset(0, -1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
  ];

  /// Convenience method to get shadows by Luky Sizes
  static List<BoxShadow> from(String level) {
    switch (level) {
      case 'sm':
        return sm;
      case 'base':
      case '':
      case 'shadow':
        return basic;
      case 'md':
        return md;
      case 'lg':
        return lg;
      case 'xl':
        return xl;
      case '2xl':
        return xxl;
      case 'inner':
        return inner;
      case 'none':
        return none;
      default:
        throw ArgumentError('Unknown shadow level: $level');
    }
  }
}
