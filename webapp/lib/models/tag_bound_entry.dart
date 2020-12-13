import "dart:convert" show JsonUnsupportedObjectError;

import "package:meta/meta.dart" show required;

import "entry.dart" show Entry;

class TagBoundEntry extends Entry {
  final String tagId;
  final DateTime boundAt;
  final String boundBy;

  factory TagBoundEntry.fromJson(
      final String tagId, final Map<String, dynamic> dto) {
    assert(dto != null);

    final String boundAtRaw = dto["boundAt"];
    if (boundAtRaw == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'boundAt' field of tag bound object.");
    }
    final DateTime boundAt = DateTime.parse(boundAtRaw).toLocal();

    final String boundBy = dto["boundBy"];
    if (boundBy == null) {
      throw JsonUnsupportedObjectError(dto,
          partialResult: "Cannot parse 'boundBy' field of tag bound object.");
    }

    return TagBoundEntry._internal(tagId, boundAt: boundAt, boundBy: boundBy);
  }

  Map<String, dynamic> toJson() => {
        "boundAt": this.boundAt.toUtc().toIso8601String(),
        "boundBy": this.boundBy,
      };

  TagBoundEntry._internal(
    this.tagId, {
    @required this.boundAt,
    @required this.boundBy,
  });
}
