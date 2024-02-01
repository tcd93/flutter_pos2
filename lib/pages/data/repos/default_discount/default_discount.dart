import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'default_discount.g.dart';

@riverpod
class DefaultDiscount extends _$DefaultDiscount {
  @override
  Future<double> build() async {
    final db = ref.read(dbProvider);
    final query = db.select(db.defaultDiscount)..limit(1);
    return query.map((row) => row.rate).getSingle();
  }

  Future<dynamic> set(double rate) async {
    assert(rate >= 0.0 && rate <= 1.0);
    state = AsyncData(rate);
    final db = ref.read(dbProvider);
    final query = db.update(db.defaultDiscount);
    return query.write(
      DefaultDiscountCompanion(rate: Value(state.requireValue)),
    );
  }
}
