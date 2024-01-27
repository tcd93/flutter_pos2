import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ephemeral.g.dart';

@Riverpod(keepAlive: true)
class Login extends _$Login {
  @override
  bool build() => false;

  void login() => state = true;

  void logout() => state = false;
}

@Riverpod(keepAlive: true)
class PageStatus extends _$PageStatus {
  @override
  Status build() => const Status();

  void current(int pageID) => state = state.copyWith(current: pageID);

  void select(int pageID) => state = state.copyWith(selected: pageID);
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
