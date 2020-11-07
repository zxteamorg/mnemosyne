import "dart:async";
import "dart:convert";

import "package:http/http.dart";
import "package:http/testing.dart";
import "package:zxteamorg_mnemosyne/mnemo.dart";

import "mnemo_attribute.dart";

class MnemoMockClient extends MockClient {
  static final _initialMnemos = [
    {
      "id": "11",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "12",
      "mime": "image/png",
      "attrs": [
        {"kind": COMMON_KIND, "name":"My first file","date":"2020-11-07T14:11:05.368Z"},
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500},
        {"kind": THUMBNAIL_KIND, "mime": "image/png", "data": "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"}
      ]
    },
    {
      "id": "13",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "14",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "15",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "16",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "17",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "18",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "19",
      "mime": "image/png",
      "attrs": [
        {"kind": COMMON_KIND, "name":"My second file","date":"2020-11-07T14:11:05.368Z"},
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    },
    {
      "id": "20",
      "mime": "image/png",
      "attrs": [
        {"kind": UNIX_FILE_KIND, "uid": 500, "gid": 500}
      ]
    }
  ];
  static List<Mnemo> _mnemosDb;
  //static String _nextId;

  static Future<Response> _handler(Request request) async {
    try {
      if (_mnemosDb == null) {
        resetDb();
      }
      List<Mnemo> data;
      switch (request.method) {
        case "GET":
          // final id = int.tryParse(request.url.pathSegments.last);
          // if (id != null) {
          //   data = _mnemosDb
          //       .firstWhere((mnemo) => mnemo.id == id); // throws if no match
          // } else {
          //String prefix = request.url.queryParameters['name'] ?? '';
          //final regExp = RegExp(prefix, caseSensitive: false);
          data = _mnemosDb.toList(growable: false);
          // where((hero) => hero.name.contains(regExp)).toList();
          // }
          break;
        // case 'POST':
        //   var name = json.decode(request.body)['name'];
        //   var newHero = Hero(_nextId++, name);
        //   _heroesDb.add(newHero);
        //   data = newHero;
        //   break;
        // case 'PUT':
        //   var heroChanges = Hero.fromJson(json.decode(request.body));
        //   var targetHero = _heroesDb.firstWhere((h) => h.id == heroChanges.id);
        //   targetHero.name = heroChanges.name;
        //   data = targetHero;
        //   break;
        // case 'DELETE':
        //   var id = int.parse(request.url.pathSegments.last);
        //   _heroesDb.removeWhere((hero) => hero.id == id);
        //   // No data, so leave it as null.
        //   break;
        default:
          throw "Unimplemented HTTP method ${request.method}";
      }
      return Response(json.encode(data), 200,
          headers: {"Content-Type": "application/json"});
    } catch (e) {
      if (e is JsonUnsupportedObjectError) {
        print(e.partialResult); // for demo purposes only
      } else if (e is Error) {
        print(e.stackTrace); // for demo purposes only
      } else {
        print(e);
      }
      throw e;
    }
  }

  static resetDb() {
    _mnemosDb = _initialMnemos.map((json) => Mnemo.fromJson(json)).toList();
    //_nextId = _mnemosDb.map((hero) => hero.id).fold(0, max) + 1;
  }

  // static String lookUpName(int id) =>
  //     _mnemosDb.firstWhere((hero) => hero.id == id, orElse: null)?.name;

  MnemoMockClient() : super(_handler);
}
