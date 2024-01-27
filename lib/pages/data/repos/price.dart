import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../price.g.dart';

// final _logger = Logger('Repository');

@riverpod
Future<double?> price(PriceRef ref, int cardID) {
  final db = ref.read(dbProvider);
  return db.getPrice(cardID).getSingle();
  /*
  final menu = ref.watch(dishIDProvider);
  if (!menu.hasValue) return null;

  return menu.value!.fold<double>(0.0, (p, dishID) {
    final portion = ref.watch(portionProvider(cardID, dishID)).value;
    final dish = ref.watch(dishItemProvider(dishID)).value;
    return p + (dish?.price ?? 0.0) * (portion ?? 0);
  });
  */
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
