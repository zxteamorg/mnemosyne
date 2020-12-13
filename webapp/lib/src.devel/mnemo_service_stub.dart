import "dart:convert" show jsonEncode, jsonDecode;
import "dart:html" show window;
import "dart:math" show Random;
import "package:http/http.dart" show Client;

import "../models/models.dart"
    show
        COMMON_KIND,
        Entry,
        MnemoEntry,
        THUMBNAIL_KIND,
        TagEntry,
        UNIX_FILE_KIND;
import "../models/mnemo_attribute.dart"
    show COMMON_KIND, THUMBNAIL_KIND, UNIX_FILE_KIND;
import "../src/mnemo_service_api.dart"
    show API_ORIGIN_ENVIRONMENT_VARIABLE, MnemoServiceApi;
import "../mnemo_service.dart" show MnemoService;

typedef TEntry EntryFactory<TEntry>(final Map<String, dynamic> dto);

class LocalStorageParticipant<TEntry extends Entry> {
  final EntryFactory<TEntry> _entryFactory;
  final String _initialData;
  final String _localStorageKey;

  LocalStorageParticipant(
      this._initialData, this._localStorageKey, this._entryFactory);

  Future<Iterable<TEntry>> list() async {
    try {
      if (window.localStorage.containsKey(this._localStorageKey)) {
        final String data = window.localStorage[this._localStorageKey];
        final List<dynamic> rawEntries = jsonDecode(data);
        final List<TEntry> entries =
            rawEntries.map((e) => this._entryFactory(e)).toList();
        return entries;
      }
    } catch (e) {
      print(e);
      window.localStorage.remove(this._localStorageKey);
    }

    final List<dynamic> rawEntries = jsonDecode(this._initialData);
    final List<TEntry> entries =
        rawEntries.map((e) => this._entryFactory(e)).toList();

    this.persist(entries);

    return entries;
  }

  persist(Iterable<TEntry> entries) {
    window.localStorage[this._localStorageKey] =
        jsonEncode(entries.map((e) => e.toJson()).toList());
  }
}

abstract class MnemoServiceStub implements MnemoService {
  factory MnemoServiceStub(Client http) {
    const String API_ORIGIN =
        String.fromEnvironment(API_ORIGIN_ENVIRONMENT_VARIABLE);
    if (API_ORIGIN == "stub://") {
      return _MnemoServiceProxy(_MnemoServiceStub._internal());
    } else {
      return _MnemoServiceProxy(MnemoServiceApi(http));
    }
  }
}

class _MnemoServiceProxy implements MnemoServiceStub {
  MnemoService get wrap => this._wrap;

  @override
  Future<Iterable<MnemoEntry>> listMnemos() => this.wrap.listMnemos();

  @override
  Future<Iterable<TagEntry>> listTags() => this.wrap.listTags();

  final MnemoService _wrap;

  _MnemoServiceProxy(this._wrap) {
    print("${_MnemoServiceProxy} constructed.");
  }
}

class _MnemoServiceStub implements MnemoServiceStub {
  @override
  Future<Iterable<MnemoEntry>> listMnemos() async {
    await this._randomDelay();
    await this._randomFailure(0.25);
    return this._mnemosLocalStorageParticipant.list();
  }

  @override
  Future<Iterable<TagEntry>> listTags() async {
    await this._randomDelay();
    await this._randomFailure(0.25);
    return this._tagsLocalStorageParticipant.list();
  }

  static final String _MNEMOS_LOCAL_STORAGE_KEY = "${_MnemoServiceStub}:memos";
  static final String _TAGS_LOCAL_STORAGE_KEY = "${_MnemoServiceStub}:tags";

  final Random _delayRandom;
  final Random _failureRandom;
  final LocalStorageParticipant<MnemoEntry> _mnemosLocalStorageParticipant;
  final LocalStorageParticipant<TagEntry> _tagsLocalStorageParticipant;

  _MnemoServiceStub._internal()
      : this._delayRandom = Random(),
        this._failureRandom = Random(),
        this._mnemosLocalStorageParticipant = LocalStorageParticipant(
            INITIAL_MNEMOS,
            _MNEMOS_LOCAL_STORAGE_KEY,
            (dto) => MnemoEntry.fromJson(dto)),
        this._tagsLocalStorageParticipant = LocalStorageParticipant(
            INITIAL_TAGS,
            _TAGS_LOCAL_STORAGE_KEY,
            (dto) => TagEntry.fromJson(dto)) {
    print("${_MnemoServiceStub} constructed.");
  }

  Future<void> _randomDelay() async {
    final int milliseconds = (this._delayRandom.nextDouble() * 720).truncate();
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /**
   * percentOfFailures in range [0..1] where
   * 0 - never failure
   * 1 - always failure
   */
  Future<void> _randomFailure(double percentOfFailures) async {
    if (percentOfFailures < 0 || percentOfFailures > 1) {
      throw ArgumentError.value(percentOfFailures);
    }
    final double nextRandomDouble = this._failureRandom.nextDouble();
    if (nextRandomDouble > (1 - percentOfFailures)) {
      // throw Exception("HTTP Fake Exception");
    }
  }
}

const String INITIAL_MNEMOS = '''
[
  {
    "id": "4e3ebb16-6e20-402c-a4db-1725af4aab54",
    "mime": "image/png",
    "attrs": [
      { "kind": "$COMMON_KIND", "name": "Linux penguin", "date": "2014-06-27T11:37:10.000Z"},
      { "kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500 },
      { "kind": "$THUMBNAIL_KIND", "mime": "image/png", "data": "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" }
    ],
    "tags": {
      "bbad9969-7768-446f-ae16-03aed4907417": { "boundAt": "2020-12-12T11:37:10.000Z", "boundBy": "someuser@devel" },
      "b7d3efbd-38c7-41a3-bb5c-da7b2592b98d": { "boundAt": "2020-12-12T11:37:10.000Z", "boundBy": "someuser@devel" }
    },
    "urls": [
      "http://i.stack.imgur.com/ILTQq.png",
      "https://i.stack.imgur.com/ILTQq.png"
    ]
  },
  {
    "id": "12",
    "mime": "image/png",
    "attrs": [
      { "kind": "$COMMON_KIND", "name":"My first file","date":"2020-11-07T14:11:05.368Z"},
      { "kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500 },
      { "kind": "$THUMBNAIL_KIND", "mime": "image/png", "data": "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"}
    ],
    "tags": {}
  },
  {
    "id": "13",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "14",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "15",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "16",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "17",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "18",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "19",
    "mime": "image/png",
    "attrs": [
      {"kind": "$COMMON_KIND", "name":"My second file","date":"2020-11-07T14:11:05.368Z"},
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  },
  {
    "id": "20",
    "mime": "image/png",
    "attrs": [
      {"kind": "$UNIX_FILE_KIND", "uid": 500, "gid": 500}
    ],
    "tags": {}
  }
]
''';

const String INITIAL_TAGS = '''
[
  {
    "id": "d5e537af-fc46-4e00-b586-7d327e4a66e2",
    "name": "children"
  },
  {
    "id": "b7d3efbd-38c7-41a3-bb5c-da7b2592b98d",
    "name": "engineering"
  },
  {
    "id": "588d0635-dca1-431a-8a8a-8ddbaefa8b4c",
    "name": "math"
  },
  {
    "id": "1fc452c0-2e46-41de-b70a-08a54d332b71",
    "name": "science"
  },
  {
    "id": "bbad9969-7768-446f-ae16-03aed4907417",
    "name": "technology"
  },
  {
    "id": "5432681a-ce45-4c4b-a9b8-9094445816d6",
    "name": "test"
  },
  {
    "id": "3a834549-6ed7-47d2-899b-f1e3800e9141",
    "name": "wizardry"
  },
  {
    "id": "c018c907-5134-49c7-a7c5-a50780f86e12",
    "name": "2015"
  },
  {
    "id": "c2033788-9b9e-4590-b709-557e3d2c2d39",
    "name": "2018"
  }
]
''';
