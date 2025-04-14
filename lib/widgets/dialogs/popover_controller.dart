import 'package:flutter/material.dart';

class LukyPopoverController {
  OverlayEntry? _entry;
  Function? _onDismiss;

  void show({
    required BuildContext context,
    required WidgetBuilder builder,
    required RenderBox targetBox,
    Offset offset = const Offset(0, 10),
    bool autoClose = true,
    Function()? onDismiss,
  }) {
    _onDismiss = onDismiss;
    hide(false); // remove if already showing

    final overlay = Overlay.of(context);
    final targetPosition = targetBox.localToGlobal(Offset.zero);
    final targetSize = targetBox.size;

    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // dismiss layer
          Positioned.fill(
            child: GestureDetector(
              onTap: autoClose
                  ? () {
                      hide(true);
                    }
                  : null,
              behavior: HitTestBehavior.translucent,
              child: Container(),
            ),
          ),

          // popover
          Positioned(
            left: (targetPosition.dx + offset.dx) - 5,
            top: targetPosition.dy + targetSize.height + offset.dy,
            child: builder(context),
          ),
        ],
      ),
    );

    overlay.insert(_entry!);
  }

  void hide(bool trigerDismiss) {
    _entry?.remove();
    _entry = null;
    if (trigerDismiss) {
      _onDismiss?.call();
    }
  }
}
