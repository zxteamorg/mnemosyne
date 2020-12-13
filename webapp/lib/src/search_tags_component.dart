import "dart:async" show Future;

import "package:angular/angular.dart" show Component, coreDirectives;
import "package:angular_components/angular_components.dart"
    show
        ButtonDirective,
        HasUIDisplayName,
        MaterialButtonComponent,
        MaterialChipComponent,
        MaterialChipsComponent,
        displayNameRendererDirective;

import "../models/models.dart" show TagEntry;

import "application_state.dart" show ApplicationState;
import "search_tags_state.dart" show SearchTagsState;

typedef Future<void> SeachButtonClickDelegate();

@Component(
    selector: "search_tags",
    templateUrl: "search_tags_component.html",
    directives: [
      coreDirectives,
      displayNameRendererDirective,
      ButtonDirective,
      MaterialButtonComponent,
      MaterialChipComponent,
      MaterialChipsComponent,
    ],
    styleUrls: [
      "search_tags_component.scss.css"
    ])
class SearchTagsComponent {
  final ApplicationState _appState;
  final SearchTagsState __searchTagsState;
  bool _isSeachButtonEnabled;

  SearchTagsStateImpl get _searchTagsState => this.__searchTagsState;

  bool get isSearchButtonEnabled {
    return this._isSeachButtonEnabled && this.onSearchButtonClick != null;
  }

  SeachButtonClickDelegate onSearchButtonClick;

  SearchTagsComponent(this._appState, this.__searchTagsState)
      : this._isSeachButtonEnabled = true;

  void searchButtonClick() async {
    if (this.onSearchButtonClick == null) {
      return;
    }

    this._isSeachButtonEnabled = false;
    try {
      await this.onSearchButtonClick();
    } catch (err, stackTrace) {
      print(err);
      print(stackTrace);
    } finally {
      this._isSeachButtonEnabled = true;
    }
  }

  Iterable<TagViewModel> get tags => this._appState.availableTags.map(
      (tag) => TagViewModel(tag, this._searchTagsState.hasSearchTag(tag.id)));

  void onClick(TagViewModel tag) {
    if (this._searchTagsState.hasSearchTag(tag.id)) {
      print("Disable search tag ${tag.name}");
      this._searchTagsState.removeSearchTag(tag.id);
    } else {
      print("Enable search tag ${tag.name}");
      this._searchTagsState.addSearchTag(tag.id);
    }
  }
}

class TagViewModel implements Comparable<TagViewModel>, HasUIDisplayName {
  final TagEntry _tag;
  final bool _isOn;

  String get id => this._tag.id;
  String get name => this._tag.name;
  int get priority => this._tag.priority;

  @override
  String get uiDisplayName => this._tag.name;
  bool get chipEmphasis => this._isOn ? true : null;

  const TagViewModel(this._tag, this._isOn);

  int compareTo(TagViewModel other) {
    return this._tag.id.compareTo(other._tag.id);
  }
}

class SearchTagsStateImpl extends SearchTagsState {
  final ApplicationState _appState;
  final List<String> _searchTagIds;

  SearchTagsStateImpl(this._appState) : this._searchTagIds = List();

  @override
  Iterable<String> get searchTagIds => this._searchTagIds;

  @override
  Iterable<TagEntry> get searchTags {
    return this
        ._appState
        .availableTags
        .where((tag) => this._searchTagIds.contains(tag.id));
  }

  void addSearchTag(final String tagId) => this._searchTagIds.add(tagId);
  bool hasSearchTag(final String tagId) => this._searchTagIds.contains(tagId);
  void removeSearchTag(final String tagId) => this._searchTagIds.remove(tagId);
}
