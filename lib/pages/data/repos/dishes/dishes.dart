import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dishes.g.dart';

// final _logger = Logger('Dishes Repo');

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
