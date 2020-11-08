import "package:angular_components/angular_components.dart"
    show HasUIDisplayName;

class TagChip implements Comparable<TagChip>, HasUIDisplayName {
  final String _tag;

  @override
  String get uiDisplayName => this._tag;

  const TagChip(this._tag);

  int compareTo(TagChip other) {
    return this._tag.compareTo(other._tag);
  }
}
