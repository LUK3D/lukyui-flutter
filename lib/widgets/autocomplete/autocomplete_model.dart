/// ## AutocompleteModel
class LukyAutocompleteModel<T> {
  String value;
  String title;
  String? description;
  String searchableContent;
  T? data;

  LukyAutocompleteModel({
    required this.value,
    required this.title,
    this.description,
    required this.searchableContent,
    this.data,
  });
}

enum LukyAutocompleteVariant {
  flat,
  bordered,
  underlined,
  faded,
}
