/// ## LukyAccordionItemModel.
/// Represents an individual item in the accordion.
class LukyAccordionItemModel {
  /// The unique identifier for the accordion item.
  final String id;

  /// The title of the accordion item.
  final String title;

  /// The content of the accordion item.
  final String description;

  /// Indicates whether the accordion item is expanded or collapsed.
  bool isExpanded;

  /// Optional data associated with the accordion item.
  final dynamic data;

  LukyAccordionItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.data,
    this.isExpanded = false,
  });
}
