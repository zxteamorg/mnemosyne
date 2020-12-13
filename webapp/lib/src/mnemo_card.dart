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

import "../models/models.dart"
    show
        CommonAttribute,
        MnemoEntry,
        TagEntry,
        ThumbnailAttribute,
        UnixFileAttribute;

import "application_state.dart" show ApplicationState;
import "search_tags_state.dart" show SearchTagsState;
import "tag_chip.dart" show TagChip;

@Component(
  selector: "mnemo-card",
  templateUrl: "mnemo_card.html",
  styleUrls: [
    "package:angular_components/css/mdc_web/card/mdc-card.scss.css",
    "mnemo_card.scss.css"
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
  MnemoEntry _mnemo;
  // SearchTagsProvider _searchTagsProvider;
  final DomSanitizationService _sanitizer;
  //final MnemoService _mnemoService;
  final ApplicationState _applicationState;
  final SearchTagsState _searchTagsState;

  MnemoCardComponent(
      this._sanitizer, this._applicationState, this._searchTagsState) {
    // Timer.periodic(Duration(seconds: 5), (_) {
    //   final String nowIsoStr = DateTime.now().toIso8601String();
    //   this._ownTags.add((nowIsoStr));
    // });
  }

  MnemoEntry get mnemo {
    if (this._mnemo == null) {
      throw StateError(
          "An input 'mnemo' is not attached to the component '${(MnemoCardComponent).toString()}'");
    }
    return this._mnemo;
  }

  @Input()
  void set mnemo(MnemoEntry value) {
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

  List<TagEntry> get _ownTags {
    final List<TagEntry> entries = this
        ._applicationState
        .availableTags
        .where((tag) => this
            ._mnemo
            .tags
            .where((boundTag) => boundTag.tagId == tag.id)
            .isNotEmpty)
        // .where((element) => [
        //       ("science"),
        //       ("math"),
        //       ("wizardry"),
        //       ("technology"),
        //       ("test"),
        //       ("engineering")
        //     ].contains(element.name))
        .toList();
    // print(this._applicationState.availableTags);
    //print(entries.length);
    return entries;
  }

  /**
   * Теги которые есть в поиске и имеются в наличии у Mnemo
   */
  Iterable<TagChip> get intersectTags => this
      ._searchTagsState
      .searchTags
      .where((searchTag) =>
          this._ownTags.where((ownTag) => ownTag == searchTag).isNotEmpty)
      .map((tag) => TagChip(tag))
      .toList()
        ..sort();

  /**
   * Теги имеются в наличии у Mnemo но нет в поиске
   */
  Iterable<TagChip> get exclusiveTags => this
      ._ownTags
      .where((ownTag) => this
          ._searchTagsState
          .searchTags
          .where((searchTag) => ownTag == searchTag)
          .isEmpty)
      .map((tag) => TagChip(tag))
      .toList()
        ..sort();

  /**
   * Теги которые есть в поиске и но НЕ имеются в наличии у Mnemo
   */
  Iterable<TagChip> get unusedTags => this
      ._searchTagsState
      .searchTags
      .where((searchTag) =>
          this._ownTags.where((ownTag) => ownTag == searchTag).isEmpty)
      .map((tag) => TagChip(tag))
      .toList()
        ..sort();

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
