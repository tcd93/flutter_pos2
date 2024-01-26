part of 'db.dart';

final _logger = Logger('Repository');

@riverpod
double? price(PriceRef ref, int cardID) {
  final menu = ref.watch(dishIDProvider);
  if (!menu.hasValue) return null;

  return menu.value!.fold<double>(0.0, (p, dishID) {
    final portion = ref.watch(portionProvider(cardID, dishID)).value;
    final dish = ref.watch(dishItemProvider(dishID)).value;
    return p + (dish?.price ?? 0.0) * (portion ?? 0);
  });
}

@riverpod
Future<List<({DateTime dateTime, double? price})>> priceByDate(
    PriceByDateRef ref, DateTimeRange range) {
  final db = ref.read(dbProvider);
  return db
      .getPriceByDate(
        DateUtils.dateOnly(range.start),
        DateUtils.dateOnly(range.end),
      )
      .map((r) => (dateTime: r.date, price: r.priceByDate))
      .get();
}

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

@riverpod
class DishID extends _$DishID {
  @override
  Future<List<int>> build() {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.dishes)..addColumns([db.dishes.id]);
    return query.map((row) => row.read(db.dishes.id)!).get();
  }
}

@riverpod
class DishItem extends _$DishItem {
  @override
  Future<Dish> build(int dishID) {
    final db = ref.read(dbProvider);
    final query = db.select(db.dishes)..where((tbl) => tbl.id.equals(dishID));
    return query.getSingle();
  }
}

@riverpod
class Note extends _$Note {
  @override
  Future<String?> build(int cardID) async {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.servingsNote)
      ..addColumns([db.servingsNote.note])
      ..where(db.servingsNote.cardID.equals(cardID));
    return query.map((row) => row.read(db.servingsNote.note)).getSingleOrNull();
  }

  Future<dynamic> takeNote(String note) async {
    state = AsyncData(note);
    return _updateSource();
  }

  Future<dynamic> _updateSource() {
    final db = ref.read(dbProvider);
    return db.into(db.servingsNote).insertOnConflictUpdate(
          ServingsNoteCompanion.insert(
            cardID: Value(cardID),
            note: Value(state.value),
          ),
        );
  }
}

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

@riverpod
class Portion extends _$Portion {
  final _logger = Logger('Portion Provider');

  @override
  Future<int?> build(int cardID, int dishID) async {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.servings)
      ..addColumns([db.servings.portion])
      ..where(
        db.servings.cardID.equals(cardID) & db.servings.dishID.equals(dishID),
      );
    return query.map((row) => row.read(db.servings.portion)).getSingleOrNull();
  }

  Future<dynamic> updateOrDelete(int portion) {
    if (portion < 0) {
      return Future.value(-1);
    }
    state = AsyncData(portion);
    return _updateSource();
  }

  Future<dynamic> _updateSource() {
    int cardID = ref.read(selectedCardProvider)!;
    final db = ref.read(dbProvider);
    if (state.value == 0) {
      _logger.info('Removing 0 value record from DB');
      final query = db.delete(db.servings)
        ..where((tbl) => tbl.cardID.equals(cardID) & tbl.dishID.equals(dishID));
      return query.go();
    }
    return db.into(db.servings).insertOnConflictUpdate(
          ServingsCompanion.insert(
            cardID: cardID,
            dishID: dishID,
            portion: state.value!,
          ),
        );
  }
}
