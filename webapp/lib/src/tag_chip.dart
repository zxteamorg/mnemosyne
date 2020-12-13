import "package:angular_components/angular_components.dart"
    show HasUIDisplayName;

import "../models/models.dart" show TagEntry;

class TagChip implements Comparable<TagChip>, HasUIDisplayName {
  final TagEntry _tag;

  @override
  String get uiDisplayName => this._tag.name;

  const TagChip(this._tag);

  int compareTo(TagChip other) {
    return this._tag.name.compareTo(other._tag.name);
  }
}
