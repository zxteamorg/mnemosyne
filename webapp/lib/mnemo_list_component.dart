import "dart:async";
import "dart:convert";

import "package:angular/angular.dart";

import "mnemo.dart";
import "mnemo_card.dart";
import "mnemo_service.dart";

@Component(
  selector: "mnemo-list",
  templateUrl: "mnemo_list_component.html",
  providers: [MnemoService],
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

  // Future<void> add(final String auditId) async {
  //   assert(auditId != null);
  //   assert(!auditId.isEmpty);

  //   try {
  //     auditEntries.add(await _auditService.fetchById(auditId));
  //   } catch (e) {
  //     errorMessage = e.toString();
  //   }
  // }
}
