import "../models/models.dart" show TagEntry;

abstract class SearchTagsState {
  Iterable<TagEntry> get searchTags;
  Iterable<String> get searchTagIds;
}
