import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:flutter_pos/pages/data/repos/dishes/dishes.dart';
import 'package:flutter_pos/pages/data/repos/servings/servings.dart';
import 'package:flutter_pos/pages/data/repos/servings_note/servings_note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions.g.dart';

@riverpod
class Transaction extends _$Transaction {
  @override
  Transaction build(int cardID) => this;

  Future<int> checkOut(double amount, String? note) async {
    final db = ref.read(dbProvider);
    final transDate = DateUtils.dateOnly(DateTime.now());
    final secondsSinceMidnight = DateTime.now().difference(transDate).inSeconds;

    for (final dishID in ref.read(dishIDProvider).requireValue) {
      ref.invalidate(portionProvider(cardID, dishID));
    }
    ref.invalidate(noteProvider(cardID));

    return db.into(db.transactions).insert(
          TransactionsCompanion.insert(
            cardID: cardID,
            date: transDate,
            time: Value(secondsSinceMidnight),
            price: Value(amount),
            note: Value(note),
          ),
        );
  }
}
