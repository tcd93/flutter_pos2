extension DiscountRateExt on double {
  /// 1.0 => no discount (0% discounted)
  /// 0.9 => 10% discount
  double toPercent() {
    assert(this >= 0 && this <= 1, 'rate must be between 0 and 1');
    return double.parse((1.0 - this).toStringAsFixed(2)) * 100;
  }

  /// 1.0 => no discount (0% discounted)
  /// 0.9 => 10% discount
  String toPercentStr() {
    return '${toPercent().toStringAsFixed(1)}%';
  }

  /// 100% => 0.0
  /// 10% => 0.9
  double toRate() {
    return double.parse((1.0 - (this / 100)).toStringAsFixed(2));
  }
}
