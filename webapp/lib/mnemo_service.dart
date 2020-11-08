import "dart:async";
import "dart:convert";

import "package:http/http.dart";

import "mnemo.dart";

class MnemoService {
  final List<String> _searchTags = List.from(
      [("science"), ("math"), ("wizardry"), ("2015"), ("2018"), ("children")],
      growable: true);
  static final _headers = {"Content-Type": "application/json"};
  static const _apiUrl = "http://localhost:5000/audit"; // URL to web API
  final Client _http;

  MnemoService(this._http) {
    print("Construct '${(MnemoService).toString()}' instance");
    Timer.periodic(Duration(seconds: 5), (_) {
      final String nowIsoStr = DateTime.now().toIso8601String();
      this._searchTags.add("st-$nowIsoStr");
      print(this._searchTags.length);
    });
  }

  Iterable<String> get searchTags => this._searchTags;

  Future<List<Object>> list() async {
    try {
      final Response response = await _http.get(MnemoService._apiUrl, headers: MnemoService._headers);
      final List<Mnemo> mnemos = (_extractData(response) as List)
          .map((value) => Mnemo.fromJson(value))
          .toList();

      return mnemos;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Future<Mnemo> fetchById(final String auditId) async {
  //   try {
  //     final response = await _http.get(_apiUrl);
  //     final audit = Mnemo.fromJson(_extractData(response));

  //     return audit;
  //   } catch (e) {
  //     throw _handleError(e);
  //   }
  // }

  dynamic _extractData(Response resp) => json.decode(resp.body);

  Exception _handleError(dynamic e) {
    if (e is JsonUnsupportedObjectError) {
      print(e.cause); // for demo purposes only
      print(e.partialResult); // for demo purposes only
      return Exception("Server error; cause: ${e.partialResult}");
    } else if (e is Error) {
      print(e.stackTrace); // for demo purposes only
    } else {
      print(e);
    }

    return Exception("Server error; cause: $e");
  }
}
