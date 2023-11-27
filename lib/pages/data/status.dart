import 'package:flutter/material.dart';

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
