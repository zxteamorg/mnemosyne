import "dart:async" show Future;

import "package:http/http.dart" show Client;

import "../models/models.dart" show MnemoEntry, TagEntry;
import "../mnemo_service.dart" show MnemoService;

const String API_ORIGIN_ENVIRONMENT_VARIABLE = "API_ORIGIN";

class MnemoServiceApi extends MnemoService {
  final Client http;

  MnemoServiceApi(this.http);

  @override
  Future<Iterable<MnemoEntry>> listMnemos() {
    // TODO: implement listMnemos
    throw UnimplementedError();
  }

  @override
  Future<Iterable<TagEntry>> listTags() {
    // TODO: implement listTags
    throw UnimplementedError();
  }
}
