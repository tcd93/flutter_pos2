import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_items.g.dart';

final _logger = Logger('Card Items Repo');

@riverpod
class CardID extends _$CardID {
  Future<dynamic> addCard(String title) async {
    final db = ref.read(dbProvider);
    final newID = await db
        .into(db.cardItems)
        .insert(CardItemsCompanion.insert(pageID: pageID, title: title));
    state.value!.add(newID);
    ref.notifyListeners();
  }

  @override
  Future<List<int>> build(int pageID) {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.cardItems)
      ..addColumns([db.cardItems.id])
      ..where(db.cardItems.pageID.equals(pageID));
    return query.map((row) => row.read(db.cardItems.id)!).get();
  }

  Future<dynamic> remove(int cardID) async {
    final db = ref.read(dbProvider);
    try {
      await (db.delete(db.cardItems)..where((c) => c.id.equals(cardID))).go();
    } on Exception catch (ex) {
      /*787: foreign key exception*/
      if (ex.toString().contains('SqliteException(787)')) {
        _logger.warning(ex);

        return 'Table is currently serving, or there are transactional records '
            'already associated with this, can not delete, create new table instead';
      }
    }
    ref.invalidateSelf();
  }
}

@riverpod
class CardTitle extends _$CardTitle {
  @override
  Future<String?> build(int cardID) {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.cardItems)
      ..addColumns([db.cardItems.title])
      ..where(db.cardItems.id.equals(cardID));
    return query.map((row) => row.read(db.cardItems.title)).getSingleOrNull();
  }

  Future<dynamic> set(String title) async {
    state = AsyncData(title);
    return _updateSource();
  }

  Future<dynamic> _updateSource() {
    final db = ref.read(dbProvider);
    final query = db.update(db.cardItems)
      ..whereSamePrimaryKey(CardItemsCompanion(id: Value(cardID)));
    return query.write(CardItemsCompanion(title: Value(state.value!)));
  }
}
