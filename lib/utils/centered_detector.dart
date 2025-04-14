import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LukyCenteredDetector extends StatefulWidget {
  final Widget child;
  final GlobalKey parentKey;
  final void Function(bool isCentered, double centerPosition)? onCenterChanged;
  final void Function(String logs)? onChange;
  final double tolerance;
  final Duration checkInterval;
  final ScrollController? scrollController;
  final Duration debounceDuration;
  final Function(double target)? onAfterInit;
  final bool shouldCheckOnInit;
  final bool animateToInitialValue;

  const LukyCenteredDetector({
    super.key,
    required this.child,
    required this.parentKey,
    this.onCenterChanged,
    this.onChange,
    this.tolerance = 1.0,
    this.checkInterval = const Duration(milliseconds: 100),
    this.scrollController,
    this.debounceDuration = const Duration(milliseconds: 100),
    this.onAfterInit,
    this.shouldCheckOnInit = false,
    this.animateToInitialValue = false,
  });

  @override
  State<LukyCenteredDetector> createState() => _LukyCenteredDetectorState();
}

class _LukyCenteredDetectorState extends State<LukyCenteredDetector>
    with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  bool? _lastCentered;
  Duration _lastCheck = Duration.zero;
  Timer? _debounce;
  Ticker? _ticker;

  @override
  void initState() {
    super.initState();

    if (widget.shouldCheckOnInit) {
      //Wait for the first frame to be rendered before checking if the child is centered
      Future.delayed(Duration(milliseconds: 2), () {
        _checkCentered(
            ignorePositinCheck: true,
            animateScroll: widget.animateToInitialValue);
      });
    }

    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    } else {
      _ticker = createTicker(_onTick)..start();
    }
  }

  void _onScroll() {
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, _checkCentered);
  }

  void _onTick(Duration elapsed) {
    if (elapsed - _lastCheck >= widget.checkInterval) {
      _lastCheck = elapsed;
      _checkCentered();
    }
  }

  void _checkCentered(
      {bool ignorePositinCheck = false, bool animateScroll = true}) {
    final parentBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox?;
    final childBox = _childKey.currentContext?.findRenderObject() as RenderBox?;

    if (parentBox != null && childBox != null) {
      final childOffsetInParent =
          childBox.localToGlobal(Offset.zero, ancestor: parentBox).dy;

      final parentHeight = parentBox.size.height;
      final childCenter = childOffsetInParent + childBox.size.height / 2;
      final parentCenter = parentHeight / 2;

      final isCentered = (childCenter >= parentCenter - widget.tolerance &&
          childCenter <= parentCenter + widget.tolerance);

      widget.onChange?.call(
          'Child center: $childCenter, Parent center: $parentCenter, Centered: $isCentered');

      if (_lastCentered != isCentered) {
        _lastCentered = isCentered;
        widget.onCenterChanged?.call(isCentered, childCenter);
      }

      if (isCentered || ignorePositinCheck) {
        _snapToCenter(childOffsetInParent, childBox.size.height, parentHeight,
            animateScroll);
      }
    }
  }

  void _snapToCenter(double childOffsetInParent, double childHeight,
      double parentHeight, bool animateScroll) {
    if (widget.scrollController == null) return;

    final currentOffset = widget.scrollController!.offset;
    final targetOffset = currentOffset +
        childOffsetInParent +
        (childHeight / 2) -
        (parentHeight / 2);
    if (animateScroll) {
      widget.scrollController!.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      widget.scrollController!.jumpTo(
        targetOffset,
      );
    }
    widget.onAfterInit?.call(targetOffset);
    widget.onChange?.call('Snapping to $targetOffset');
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    } else {
      _ticker?.dispose();
    }
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _childKey,
      child: widget.child,
    );
  }
}
