import "models/models.dart" show MnemoEntry, TagEntry;

abstract class MnemoService {
  Future<Iterable<MnemoEntry>> listMnemos();
  Future<Iterable<TagEntry>> listTags();
}
