import 'package:flutter/material.dart';

class LukyCenterSnapListView extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double itemHeight;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final Function(double position)? onAnimateToItem;
  final bool shrinkWrap;
  final bool disableOnDemandRendering;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  const LukyCenterSnapListView({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.itemHeight,
    this.controller,
    this.padding,
    this.physics,
    this.onAnimateToItem,
    this.shrinkWrap = false,
    this.disableOnDemandRendering = false,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
  });

  @override
  State<LukyCenterSnapListView> createState() => _LukyCenterSnapListViewState();
}

class _LukyCenterSnapListViewState extends State<LukyCenterSnapListView> {
  bool _userScrolling = false;
  late final ScrollController _scrollController =
      widget.controller ?? ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Future.delayed(Duration(milliseconds: 200), () {
    //   _snapToNearestItem();
    // });
  }

  void _onScroll() {
    if (!_scrollController.position.isScrollingNotifier.value &&
        _userScrolling) {
      _userScrolling = false;
      _snapToNearestItem();
    }
  }

  void _snapToNearestItem() {
    final scrollOffset = _scrollController.offset;
    final viewportHeight = _scrollController.position.viewportDimension;

    final centerOffset = scrollOffset + viewportHeight / 2;
    final itemIndex = (centerOffset / widget.itemHeight).round();

    final targetOffset = (itemIndex * widget.itemHeight) -
        (viewportHeight - widget.itemHeight) / 2;

    if (widget.onAnimateToItem != null) {
      widget.onAnimateToItem!(targetOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ));
    } else {
      _scrollController.animateTo(
        targetOffset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          _userScrolling = true;
        } else if (notification is ScrollEndNotification) {
          // handled by _scrollController listener
        }
        return false;
      },
      child: widget.disableOnDemandRendering
          ? SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment:
                      widget.mainAxisAlignment ?? MainAxisAlignment.start,
                  crossAxisAlignment:
                      widget.crossAxisAlignment ?? CrossAxisAlignment.start,
                  children: List.generate(
                      widget.itemCount,
                      (index) => SizedBox(
                            width: double.infinity,
                            height: widget.itemHeight,
                            child: widget.itemBuilder(context, index),
                          )),
                ),
              ),
            )
          : ListView.builder(
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: _scrollController,
              itemCount: widget.itemCount,
              itemBuilder: widget.itemBuilder,
              itemExtent: widget.itemHeight, // required for snapping logic
              addAutomaticKeepAlives: true,
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
