import "package:angular/angular.dart";

import "mnemo_list_component.dart";

@Component(
  selector: 'my-app',
  template: '''
    <mnemo-list></mnemo-list>
  ''',
  directives: [MnemoListComponent],
)
class AppComponent {
  var name = 'Angular';
}
