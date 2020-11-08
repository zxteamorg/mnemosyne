import "dart:async";

import "package:angular/angular.dart" show Component, Input, coreDirectives;
import "package:angular/security.dart" show DomSanitizationService, SafeStyle;
import "package:angular_components/angular_components.dart"
    show
        MaterialButtonComponent,
        MaterialChipComponent,
        MaterialChipsComponent,
        MaterialIconComponent,
        displayNameRendererDirective;
import "package:angular_components/material_button/material_button.dart"
    show MaterialButtonComponent;
import "package:angular_components/material_icon/material_icon.dart"
    show MaterialIconComponent;
import "package:angular_components/material_chips/material_chip.dart"
    show MaterialChipComponent;
import "package:angular_components/material_chips/material_chips.dart"
    show MaterialChipsComponent;

import "mnemo.dart" show Mnemo;
import "mnemo_attribute.dart";
import "mnemo_service.dart" show MnemoService;
import "tag_chip.dart" show TagChip;
//import "search_tags_provider.dart" show SearchTagsProvider;

@Component(
  selector: "mnemo-card",
  templateUrl: "mnemo_card.html",
  styleUrls: [
    "package:angular_components/css/mdc_web/card/mdc-card.scss.css",
    "mnemo_card.css"
  ],
  directives: [
    coreDirectives,
    displayNameRendererDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialChipComponent,
    MaterialChipsComponent,
  ],
)
class MnemoCardComponent {
  Mnemo _mnemo;
  // SearchTagsProvider _searchTagsProvider;
  final DomSanitizationService _sanitizer;
  final MnemoService _mnemoService;

  MnemoCardComponent(this._sanitizer, this._mnemoService) {
    // Timer.periodic(Duration(seconds: 5), (_) {
    //   final String nowIsoStr = DateTime.now().toIso8601String();
    //   this._ownTags.add((nowIsoStr));
    // });
  }

  Mnemo get mnemo {
    if (this._mnemo == null) {
      throw StateError(
          "An input 'mnemo' is not attached to the component '${(MnemoCardComponent).toString()}'");
    }
    return this._mnemo;
  }

  @Input()
  void set mnemo(Mnemo value) {
    this._mnemo = value;
  }

  String get id => this.mnemo.id;
  String get mime => this.mnemo.mime;

  CommonAttribute get commonAttribute =>
      this.mnemo.getAttribute<CommonAttribute>();
  ThumbnailAttribute get thumbnailAttribute =>
      this.mnemo.getAttribute<ThumbnailAttribute>();
  UnixFileAttribute get unixFileAttribute =>
      this.mnemo.getAttribute<UnixFileAttribute>();

  List<String> _ownTags = List.from(
      [("science"), ("math"), ("wizardry"), ("technology"), ("engineering")],
      growable: true);

  Iterable<TagChip> get intersectTags => this
      ._mnemoService
      .searchTags
      .where((searchTag) =>
          this._ownTags.where((ownTag) => ownTag == searchTag).isNotEmpty)
      .map((tag) => TagChip(tag));
  Iterable<TagChip> get exclusiveTags => this
      ._ownTags
      .where((ownTag) => this
          ._mnemoService
          .searchTags
          .where((searchTag) => ownTag == searchTag)
          .isEmpty)
      .map((tag) => TagChip(tag));
  Iterable<TagChip> get unusedTags => this
      ._mnemoService
      .searchTags
      .where((searchTag) =>
          this._ownTags.where((ownTag) => ownTag == searchTag).isEmpty)
      .map((tag) => TagChip(tag));

  bool get hasCommonAttribute =>
      this.mnemo.findAttribute<CommonAttribute>() != null;
  bool get hasThumbnailAttribute =>
      this.mnemo.findAttribute<ThumbnailAttribute>() != null;
  bool get hasUnixFileAttribute =>
      this.mnemo.findAttribute<UnixFileAttribute>() != null;

  SafeStyle get mediaStyle {
    final ThumbnailAttribute attr =
        this.mnemo.findAttribute<ThumbnailAttribute>();

    String thumbnailUrl;

    if (attr != null) {
      thumbnailUrl = "url('data:${attr.mime};base64,${attr.dataBase64}')";
    } else {
      thumbnailUrl = "url('assets/thumbnail-fallback/_.png')";
    }

    final String style = "background-image: $thumbnailUrl";
    final SafeStyle trustedStyle =
        this._sanitizer.bypassSecurityTrustStyle(style);

    return trustedStyle;
  }
}
