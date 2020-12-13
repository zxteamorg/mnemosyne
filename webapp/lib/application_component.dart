import "dart:convert" show JsonUnsupportedObjectError;

import "package:angular/angular.dart";

import "src/application_state.dart" show ApplicationState;
import "src/mnemo_list_component.dart" show MnemoListComponent;
import "src/search_tags_component.dart"
    show SearchTagsComponent, SearchTagsStateImpl;
import "src/search_tags_state.dart" show SearchTagsState;

import "models/models.dart" show TagEntry;

import "mnemo_service.dart" show MnemoService;

@Component(selector: "mnemosyne-app", template: """
    <search_tags #searchTags></search_tags>
    <mnemo-list #mnemos></mnemo-list>
  """, directives: [
  MnemoListComponent,
  SearchTagsComponent
], providers: [
  ClassProvider(ApplicationState, useClass: ApplicationStateImpl),
  ClassProvider(SearchTagsState, useClass: SearchTagsStateImpl)
])
class ApplicationComponent implements OnInit {
  @ViewChild("mnemos")
  MnemoListComponent mnemos;

  @ViewChild("searchTags")
  SearchTagsComponent searchTags;

  final MnemoService _mnemoService;
  final ApplicationState __appState;
  bool _isReloading;

  ApplicationStateImpl get _appState => this.__appState;

  ApplicationComponent(this._mnemoService, this.__appState)
      : this._isReloading = false;

  @override
  void ngOnInit() {
    if (this.mnemos == null) {
      throw StateError("A mnemos was not bound. Please check.");
    }

    if (this.searchTags == null) {
      throw StateError("A searchTags was not bound. Please check.");
    }

    this.searchTags.onSearchButtonClick = this._reload;
    //this.searchTags.onSearchButtonClick = this.mnemos.reload;

    this._reload().catchError((err) => print(err));
  }

  Future<void> _reload() async {
    if (this._isReloading) {
      throw StateError("Cannot _reload() twice.");
    }
    this._isReloading = true;
    try {
      this.mnemos.reset();
      final Iterable<TagEntry> tags = await this._mnemoService.listTags();
      this._appState.availableTags = tags;
      await this.mnemos.reload();
    } catch (e) {
      if (e is JsonUnsupportedObjectError) {
        print(e.partialResult); // for demo purposes only
      } else if (e is Error) {
        print(e.stackTrace); // for demo purposes only
      } else {
        print(e); // for demo purposes only
      }
    } finally {
      this._isReloading = false;
    }
  }
}

class ApplicationStateImpl extends ApplicationState {
  Iterable<TagEntry> _availableTags;

  @override
  Iterable<TagEntry> get availableTags {
    return this._availableTags ?? [];
  }

  void set availableTags(Iterable<TagEntry> value) {
    this._availableTags = value;
  }
}
