import "dart:convert" show JsonUnsupportedObjectError, base64;

import "dart:typed_data" show Uint8List;

const COMMON_KIND = "common";
const THUMBNAIL_KIND = "thumbnail";
const UNIX_FILE_KIND = "unixFile";

abstract class MnemoAttribute {
  final String kind;

  factory MnemoAttribute.fromJson(Map<String, dynamic> attr) {
    final String kind = attr["kind"];

    if (kind == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'kind' field.");
    }

    switch (kind) {
      case COMMON_KIND:
        return CommonAttribute.fromJson(attr);
      case THUMBNAIL_KIND:
        return ThumbnailAttribute.fromJson(attr);
      case UNIX_FILE_KIND:
        return UnixFileAttribute.fromJson(attr);
      default:
        throw JsonUnsupportedObjectError(attr,
            partialResult: "Wrong value of 'kind' field.");
    }
  }

  Map toJson();

  MnemoAttribute._internal(this.kind);
}

class CommonAttribute extends MnemoAttribute {
  final String name;
  final DateTime date;

  factory CommonAttribute.fromJson(Map<String, dynamic> attr) {
    final String name = attr["name"];
    final String dateStr = attr["date"];

    if (name == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'name' field.");
    }

    if (dateStr == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'date' field.");
    }

    final DateTime date = DateTime.parse(dateStr);

    return CommonAttribute._internal(name, date);
  }

  Map toJson() => {"kind": COMMON_KIND, "name": name, "date": date.toIso8601String()};

  CommonAttribute._internal(this.name, this.date)
      : super._internal(COMMON_KIND);
}

class ThumbnailAttribute extends MnemoAttribute {
  final Uint8List _data;
  final String mime;
  String get dataBase64 => base64.encode(this._data);

  factory ThumbnailAttribute.fromJson(Map<String, dynamic> attr) {
    final String mime = attr["mime"];
    final String dataBase64 = attr["data"];

    if (mime == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'mime' field.");
    }

    if (dataBase64 == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'data' field.");
    }

    final Uint8List data = base64.decode(dataBase64);

    return ThumbnailAttribute._internal(mime, data);
  }

  Map toJson() => {"kind": THUMBNAIL_KIND, "mime": mime, "data": dataBase64};

  ThumbnailAttribute._internal(this.mime, this._data)
      : super._internal(THUMBNAIL_KIND);
}

class UnixFileAttribute extends MnemoAttribute {
  final int uid;
  final int gid;
  //final int perm;

  factory UnixFileAttribute.fromJson(Map<String, dynamic> attr) {
    final int uid = attr["uid"];
    final int gid = attr["gid"];

    if (uid == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'uid' field.");
    }

    if (gid == null) {
      throw JsonUnsupportedObjectError(attr,
          partialResult: "Cannot parse 'gid' field.");
    }

    return UnixFileAttribute._internal(uid, gid);
  }

  Map toJson() => {"kind": UNIX_FILE_KIND, "uid": uid, "gid": gid};

  UnixFileAttribute._internal(this.uid, this.gid)
      : super._internal(UNIX_FILE_KIND);
}
