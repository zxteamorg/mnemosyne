import "package:angular/angular.dart" show Component, Input, coreDirectives;
import "package:angular/security.dart" show DomSanitizationService, SafeStyle;
import "package:angular_components/angular_components.dart"
    show
        HasUIDisplayName,
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
  DomSanitizationService _sanitizer;

  MnemoCardComponent(this._sanitizer);

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

  Iterable<TagChip> get ownTags => List.from([
        TagChip('science'),
        TagChip('math'),
        TagChip('wizardry'),
        TagChip('technology'),
        TagChip('engineering')
      ]);
  Iterable<TagChip> get searchTags => List.from([
        TagChip('science'),
        TagChip('math'),
        TagChip('wizardry'),
        TagChip('2015'),
        TagChip('2018'),
        TagChip('children')
      ]);

  Iterable<TagChip> get intersectTags =>
      this.searchTags.where((searchTag) => this
          .ownTags
          .where((ownTag) => ownTag.uiDisplayName == searchTag.uiDisplayName)
          .isNotEmpty);
  Iterable<TagChip> get exclusiveTags => this.ownTags.where((ownTag) => this
      .searchTags
      .where((searchTag) => ownTag.uiDisplayName == searchTag.uiDisplayName)
      .isEmpty);
  Iterable<TagChip> get unusedTags => this.searchTags.where((searchTag) => this
      .ownTags
      .where((ownTag) => ownTag.uiDisplayName == searchTag.uiDisplayName)
      .isEmpty);

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

class TagChip implements Comparable<TagChip>, HasUIDisplayName {
  @override
  final String uiDisplayName;
  const TagChip(this.uiDisplayName);

  int compareTo(TagChip other) {
    return this.uiDisplayName.compareTo(other.uiDisplayName);
  }
}
