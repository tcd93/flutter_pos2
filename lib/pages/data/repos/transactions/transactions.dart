import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/data/repos/price.dart';
import 'package:flutter_pos/pages/data/repos/servings/servings.dart';
import 'package:flutter_pos/pages/data/repos/servings_note/servings_note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@riverpod
class Transaction extends _$Transaction {
  @override
  Transaction build(int cardID) => this;

  Future<int> checkOut(int cardID) async {
    final db = ref.read(dbProvider);
    final price = ref.read(originalPriceProvider(cardID)).value ?? 0.0;
    final discountRate = ref.read(discountRateProvider(cardID));
    final note = ref.read(noteProvider(cardID)).value;
    final transDate = DateUtils.dateOnly(DateTime.now());
    final secondsSinceMidnight = DateTime.now().difference(transDate).inSeconds;

    for (final dishID in ref.read(dishIDProvider).requireValue) {
      ref.invalidate(portionProvider(cardID, dishID));
    }
    ref.invalidate(noteProvider(cardID));
    ref.invalidate(originalPriceProvider(cardID));
    ref.invalidate(priceProvider(cardID));

    return db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            cardID: cardID,
            date: transDate,
            time: Value(secondsSinceMidnight),
            price: Value(price),
            discountRate: Value(discountRate),
            note: Value(note),
          ),
        );
  }
}
