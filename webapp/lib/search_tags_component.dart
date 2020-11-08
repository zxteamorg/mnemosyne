import "package:angular/angular.dart" show Component, coreDirectives;
import "package:angular_components/angular_components.dart"
    show MaterialChipComponent, MaterialChipsComponent, displayNameRendererDirective;

import "mnemo_service.dart";
import "tag_chip.dart";

@Component(
  selector: "search_tags",
  templateUrl: "search_tags_component.html",
  directives: [
    coreDirectives,
    displayNameRendererDirective,
    MaterialChipComponent,
    MaterialChipsComponent,
  ],
)
class SearchTagsComponent {
  final MnemoService _mnemoService;

  SearchTagsComponent(this._mnemoService);

  Iterable<TagChip> get searchTags =>
      this._mnemoService.searchTags.map((tag) => TagChip(tag));

  void onClick(TagChip tagChip) {
    print(tagChip);
  }
}
