import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/image_type.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dishes.g.dart';

final _logger = Logger('Dishes Repo');

@riverpod
class DishID extends _$DishID {
  @override
  Future<List<int>> build() {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.dishes)..addColumns([db.dishes.id]);
    return query.map((row) => row.read(db.dishes.id)!).get();
  }

  Future<dynamic> add(String name) async {
    final db = ref.read(dbProvider);
    final newID = await db.into(db.dishes).insert(
          DishesCompanion.insert(
            name: name,
            price: 0.0,
            imageType: ImageType.blank,
          ),
        );
    state.value!.add(newID);
    ref.notifyListeners();
  }

  Future<dynamic> remove(int dishID) async {
    // final db = ref.read(dbProvider);
    // return (db.delete(db.dishes)..where((tbl) => tbl.id.equals(dishID))).go();

    final db = ref.read(dbProvider);
    try {
      await (db.delete(db.dishes)..where((c) => c.id.equals(dishID))).go();
    } on Exception catch (ex) {
      /*787: foreign key exception*/
      if (ex.toString().contains('SqliteException(787)')) {
        _logger.warning(ex);

        return 'Dishes, or there are transactional records '
            'already associated with this, can not delete, create new dish instead';
      }
    }
    ref.invalidateSelf();
    // invalidate DishItemProvider manually as it has keepAlive: true
    ref.invalidate(dishItemProvider(dishID));
  }
}

@Riverpod(keepAlive: true)
class DishItem extends _$DishItem {
  @override
  Future<Dish> build(int dishID) {
    final db = ref.read(dbProvider);
    final query = db.select(db.dishes)..where((tbl) => tbl.id.equals(dishID));
    return query.getSingle();
  }

  Future<dynamic> set(String name, double price) {
    state = AsyncData(state.requireValue.copyWith(
      name: name,
      price: price,
    ));
    final db = ref.read(dbProvider);
    final query = db.update(db.dishes)..whereSamePrimaryKey(state.requireValue);
    return query.write(state.requireValue);
  }

  void setUrl(String url) {
    if (url.trim().isEmpty) return;

    state = AsyncData(state.requireValue.copyWith(
      imageType: ImageType.url,
      imagePath: Value(url),
    ));
  }

  void setFile(String filePath) {
    state = AsyncData(state.requireValue.copyWith(
      imageType: ImageType.file,
      imagePath: Value(filePath),
    ));
  }

  void setBytes(Uint8List data) {
    state = AsyncData(state.requireValue.copyWith(
      imageType: ImageType.bytes,
      imageData: Value(data),
    ));
  }
}
