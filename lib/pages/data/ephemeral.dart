import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/repos/default_discount/default_discount.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ephemeral.g.dart';

/// discount = 1.0 => no discount
/// discount = 0.9 => 10% discount
@riverpod
class DiscountRate extends _$DiscountRate {
  @override
  double build(int cardID) {
    final defaultRate = ref.watch(defaultDiscountProvider).value ?? 1.0;
    return defaultRate;
  }

  void set(double value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class BottomSheetStatus extends _$BottomSheetStatus {
  @override
  bool build() => false;

  void set(bool open) => state = open;
}

@Riverpod(keepAlive: true)
class PageStatus extends _$PageStatus {
  @override
  Status build() => const Status();

  void current(int pageID) => state = state.copyWith(current: pageID);

  void select(int pageID) => state = state.copyWith(selected: pageID);
}

// keepAlive is important here because it's used inside pageview widget which
// gets disposed often
@Riverpod(keepAlive: true)
class EdittingDishID extends _$EdittingDishID {
  @override
  int? build() => null;

  set(int dishID) => state = dishID;
}

/// Current opened card in menu page
@Riverpod(keepAlive: true)
class SelectedCard extends _$SelectedCard {
  @override
  int? build() => null;

  void close() => state = null;

  void open(int cardID) => state = cardID;
}

@immutable
class Status {
  /// The page user selected (may not be in view port yet - still in animation)
  final int selected;

  /// The page currently in view port
  final int current;

  const Status({this.selected = 0, this.current = 0});

  Status copyWith({int? selected, int? current}) {
    return Status(
      selected: selected ?? this.selected,
      current: current ?? this.current,
    );
  }
}
