import 'package:flutter/material.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/ephemeral.dart';
import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'price.g.dart';

// final _logger = Logger('Repository');

/// Original price
@riverpod
Future<double?> originalPrice(OriginalPriceRef ref, int cardID) async {
  final db = ref.read(dbProvider);
  final price = await db.getPrice(cardID).getSingle();
  return price;
}

/// Discounted price
@riverpod
Future<double?> price(PriceRef ref, int cardID) async {
  final price = ref.watch(originalPriceProvider(cardID)).value;
  final discount = ref.watch(discountRateProvider(cardID));
  return price != null ? price * discount : null;
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

/// For report 1
@riverpod
Future<List<GetPriceByDateResult>> priceByDate(
  PriceByDateRef ref,
  DateTimeRange range,
) {
  final db = ref.read(dbProvider);
  return db
      .getPriceByDate(
        DateUtils.dateOnly(range.start),
        DateUtils.dateOnly(range.end),
      )
      .get();
}
