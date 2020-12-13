import "../models/models.dart" show TagEntry;

abstract class ApplicationState {
  Iterable<TagEntry> get availableTags;
}
