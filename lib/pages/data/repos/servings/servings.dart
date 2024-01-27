import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'servings.g.dart';

final _logger = Logger('Servings Repo');

@riverpod
class Portion extends _$Portion {
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
    ref.invalidate(priceProvider); // refresh price provider
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
