import "dart:convert" show JsonUnsupportedObjectError;

import "entry.dart" show Entry;

class TagEntry extends Entry {
  final String id;
  final String name;
  final int priority;

  factory TagEntry.fromJson(final Map<String, dynamic> dto) {
    assert(dto != null);

    final String id = dto["id"];
    final String name = dto["name"];

    if (id == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'id' field of Tag object.");
    }

    if (name == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'name' field of Tag object.");
    }

    return TagEntry._internal(id, name);
  }

  Map<String, dynamic> toJson() => {"id": this.id, "name": this.name};

  TagEntry._internal(this.id, this.name) : this.priority = 1;
}
