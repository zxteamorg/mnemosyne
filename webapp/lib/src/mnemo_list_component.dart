import "dart:async" show Future;
import "dart:convert" show JsonUnsupportedObjectError;

import "package:angular/angular.dart" show Component, OnInit, coreDirectives;

import "../models/mnemo_entry.dart" show MnemoEntry;
import "../mnemo_service.dart" show MnemoService;

import "application_state.dart" show ApplicationState;
import "mnemo_card.dart" show MnemoCardComponent;
import "search_tags_state.dart" show SearchTagsState;

@Component(
  selector: "mnemo-list",
  templateUrl: "mnemo_list_component.html",
  styles: [".error {color:red;}"],
  directives: [coreDirectives, MnemoCardComponent],
)
class MnemoListComponent implements OnInit {
  final MnemoService _mnemoService;
  final ApplicationState _appState;
  final SearchTagsState _searchTagsState;
  final List<MnemoEntry> entries;
  String errorMessage;

  MnemoListComponent(this._mnemoService, this._appState, this._searchTagsState)
      : this.entries = List();

  @override
  void ngOnInit() => reload();

  Future<void> reload() async {
    try {
      final List<String> tagIds = this._searchTagsState.searchTagIds.toList();
      this.entries.clear();

      print("Reload mnemos with filter: ${tagIds}");
      final List<MnemoEntry> entries = await _mnemoService.listMnemos();
      this.entries.addAll(entries);
    } catch (e) {
      if (e is JsonUnsupportedObjectError) {
        print(e.partialResult); // for demo purposes only
      } else if (e is Error) {
        print(e.stackTrace); // for demo purposes only
      } else {
        errorMessage = e.toString();
      }
    }
  }

  void reset() {
    this.entries.clear();
  }
}
