import "dart:convert";

import "package:zxteamorg_mnemosyne/mnemo_attribute.dart";

class Mnemo {
  final String id;
  final String mime;
  final List<MnemoAttribute> attrs;

  factory Mnemo.fromJson(Map<String, dynamic> mnemo) {
    assert(mnemo != null);

    final String id = mnemo["id"];
    final String mime = mnemo["mime"];
    final List rawAttrs = (mnemo["attrs"] as List);

    if (id == null) {
      throw JsonUnsupportedObjectError(mnemo,
          partialResult: "Cannot parse 'id' field of Mnemo object.");
    }

    if (mime == null) {
      throw JsonUnsupportedObjectError(mnemo,
          partialResult: "Cannot parse 'mime' field of Mnemo object.");
    }

    if (rawAttrs == null) {
      throw JsonUnsupportedObjectError(mnemo,
          partialResult: "Cannot parse 'attrs' field of Mnemo object.");
    }

    List<MnemoAttribute> attrs =
        rawAttrs.map((attr) => MnemoAttribute.fromJson(attr)).toList();

    return Mnemo._internal(id, mime, attrs);
  }

  Map toJson() => {
        "id": this.id,
        "mime": this.mime,
        "attrs": this.attrs.map((attr) => attr.toJson()).toList(growable: false)
      };

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

  Mnemo._internal(this.id, this.mime, this.attrs);
}
