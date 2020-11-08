import "dart:async" show Future;
import "dart:convert" show JsonUnsupportedObjectError;

import "package:angular/angular.dart" show Component, OnInit, coreDirectives;

import "mnemo.dart" show Mnemo;
import "mnemo_card.dart" show MnemoCardComponent;
import "mnemo_service.dart" show MnemoService;

@Component(
  selector: "mnemo-list",
  templateUrl: "mnemo_list_component.html",
  styles: [".error {color:red;}"],
  directives: [coreDirectives, MnemoCardComponent],
)
class MnemoListComponent implements OnInit {
  final MnemoService _mnemoService;
  String errorMessage;
  List<Mnemo> entries = null;

  MnemoListComponent(this._mnemoService);

  @override
  void ngOnInit() => _reload();

  Future<void> _reload() async {
    try {
      entries = await _mnemoService.list();
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
}
