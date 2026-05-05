import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/bookmark_model.dart';

class BookmarkService {
  late File _file;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/bookmarks.json');
    if (!await _file.exists()) {
      await _file.writeAsString('[]');
    }
  }

  Future<List<BookmarkModel>> getAll() async {
    try {
      final content = await _file.readAsString();
      final List<dynamic> list = json.decode(content);
      return list.map((e) => BookmarkModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> add(BookmarkModel bookmark) async {
    final items = await getAll();
    bookmark.id = DateTime.now().millisecondsSinceEpoch;
    items.add(bookmark);
    await _save(items);
  }

  Future<void> delete(int id) async {
    final items = await getAll();
    items.removeWhere((b) => b.id == id);
    await _save(items);
  }

  Future<void> _save(List<BookmarkModel> items) async {
    final jsonList = items.map((e) => e.toJson()).toList();
    await _file.writeAsString(json.encode(jsonList));
  }
}