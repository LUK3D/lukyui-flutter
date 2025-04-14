import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lukyui/lukyui_components.dart';

class LukyScrollController extends ScrollController {
  late final String id;
  final Function? onStartScroll;
  final Function? onEndScroll;
  bool _isScrolling = false;
  Timer? _scrollTimer;
  final bool blockOnScroll;

  LukyScrollController({
    String? id,
    this.blockOnScroll = false,
    this.onEndScroll,
    this.onStartScroll,
  }) {
    this.id = id ?? UniqueKey().toString();
    addListener(_onScrollChange);
  }

  _onScrollChange() {
    if (!_isScrolling) {
      LukyScrollsManager().blockScrolls(id);
      onStartScroll?.call();
      _isScrolling = true;
    }

    _isScrolling = true;
    _scrollTimer?.cancel();
    _scrollTimer = Timer(const Duration(milliseconds: 100), () {
      _isScrolling = false;
      onEndScroll?.call();
      LukyScrollsManager().unblockScrolls(id);
    });
  }

  @override
  void dispose() {
    removeListener(_onScrollChange);
    _scrollTimer?.cancel();
    super.dispose();
  }
}

class LukyScrollsManager {
  static final LukyScrollsManager _instance = LukyScrollsManager._internal();
  factory LukyScrollsManager() {
    return _instance;
  }
  LukyScrollsManager._internal();

  List<String> scrollBlockers = [];

  bool get isBlocked => scrollBlockers.isNotEmpty;

  LukyEventSystem events = LukyEventSystem();

  void blockScrolls(String id) {
    if (!scrollBlockers.contains(id)) {
      scrollBlockers.add(id);
    }
    events.emit(LukyScrollChangeEvent(
      id: id,
      isScrolling: true,
      isBlocked: isBlocked,
    ));
  }

  void unblockScrolls(String id) {
    scrollBlockers.remove(id);
    events.emit(LukyScrollChangeEvent(
      id: id,
      isScrolling: false,
      isBlocked: isBlocked,
    ));
  }
}
