import "dart:convert" show JsonUnsupportedObjectError;

import "package:meta/meta.dart" show required;
import 'package:zxteamorg_mnemosyne/models/tag_bound_entry.dart';

import "entry.dart" show Entry;
import "mnemo_attribute.dart" show MnemoAttribute;

class MnemoEntry extends Entry {
  final String id;
  final String mime;
  final List<MnemoAttribute> attrs;
  final List<TagBoundEntry> tags;

  factory MnemoEntry.fromJson(final Map<String, dynamic> dto) {
    assert(dto != null);

    final String id = dto["id"];
    if (id == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'id' field of Mnemo object.");
    }

    final String mime = dto["mime"];
    if (mime == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'mime' field of Mnemo object.");
    }

    final List<dynamic> rawAttrs = dto["attrs"];
    if (rawAttrs == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'attrs' field of Mnemo object.");
    }

    final List<MnemoAttribute> attrs =
        rawAttrs.map((attr) => MnemoAttribute.fromJson(attr)).toList();

    final Map<String, dynamic> rawTags = dto["tags"];
    if (rawTags == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'tags' field of Mnemo object.");
    }
    final List<TagBoundEntry> tags = rawTags.keys.map((String tagId) {
      final Map<String, dynamic> rawTagDto = rawTags[tagId];
      return TagBoundEntry.fromJson(tagId, rawTagDto);
    }).toList();

    return MnemoEntry._internal(id, mime: mime, attrs: attrs, tags: tags);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> tags = {};
    for (final TagBoundEntry tag in this.tags) {
      tags[tag.tagId] = tag.toJson();
    }

    return {
      "id": this.id,
      "mime": this.mime,
      "attrs": this.attrs.map((attr) => attr.toJson()).toList(growable: false),
      "tags": tags
    };
  }

  T findAttribute<T extends MnemoAttribute>() {
    final Iterable<MnemoAttribute> search =
        this.attrs.where((element) => element is T);
    return search.isNotEmpty ? search.single as T : null;
  }

  T getAttribute<T extends MnemoAttribute>() {
    final Iterable<MnemoAttribute> search =
        this.attrs.where((element) => element is T);
    if (search.isEmpty) {
      throw StateError(
          "Wrong operation. Mnemo '$id' does not have attribure '${(T).toString()}'");
    }
    return search.single;
  }

  MnemoEntry._internal(
    this.id, {
    @required this.mime,
    @required this.attrs,
    @required this.tags,
  });
}
