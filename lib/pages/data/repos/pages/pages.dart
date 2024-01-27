import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pages.g.dart';

final _logger = Logger('Pages Repo');

@riverpod
class PageID extends _$PageID {
  Future<dynamic> addPage(String title) async {
    final db = ref.read(dbProvider);
    final newID = await db
        .into(db.pages)
        .insert(PagesCompanion.insert(name: Value(title)));
    state.value!.add(newID);
    ref.notifyListeners();
  }

  @override
  Future<List<int>> build() {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.pages)..addColumns([db.pages.id]);
    return query.map((row) => row.read(db.pages.id)!).get();
  }

  Future<dynamic> remove(int pageID) async {
    final db = ref.read(dbProvider);
    _logger.info('Deleting page: $pageID ');
    try {
      await (db.delete(db.pages)..where((c) => c.id.equals(pageID))).go();
    } on Exception catch (ex) {
      /*787: foreign key exception*/
      if (ex.toString().contains('SqliteException(787)')) {
        _logger.warning(ex);

        return 'Page contains table, can not delete';
      }
    }
    ref.invalidateSelf();
    ref.invalidate(pageNameProvider(pageID));
  }
}

@riverpod
class PageName extends _$PageName {
  @override
  Future<String?> build(int pageID) {
    final db = ref.read(dbProvider);
    final col = ifNull(db.pages.name, db.pages.asset);
    final query = db.selectOnly(db.pages)
      ..addColumns([col])
      ..where(db.pages.id.equals(pageID));
    return query.map((row) => row.read(col)).getSingleOrNull();
  }
}
