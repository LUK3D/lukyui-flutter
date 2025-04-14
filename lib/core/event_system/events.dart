class LukyScrollChangeEvent {
  final String id;
  final bool isScrolling;
  final bool isBlocked;

  LukyScrollChangeEvent(
      {required this.id, required this.isScrolling, required this.isBlocked});
}
