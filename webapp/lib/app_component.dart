import "package:angular/angular.dart";

import "mnemo_list_component.dart" show MnemoListComponent;
import "mnemo_service.dart" show MnemoService;
import "search_tags_component.dart" show SearchTagsComponent;

@Component(
  selector: "my-app",
  template: """
    <search_tags></search_tags>
    <mnemo-list></mnemo-list>
  """,
  providers: [MnemoService],
  directives: [MnemoListComponent, SearchTagsComponent],
)
class AppComponent {
  String name = "Angular";
}
