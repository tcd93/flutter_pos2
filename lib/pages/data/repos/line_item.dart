import 'package:flutter_pos/pages/data/repos/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'line_item.g.dart';

@riverpod
class LineItems extends _$LineItems {
  @override
  Future<List<LineItem>> build(int cardID) async {
    final db = ref.read(dbProvider);
    final query = db.getServingLines(cardID).map(
          (row) => LineItem(
            dishName: row.name,
            quantity: row.portion,
            price: row.price,
          ),
        );
    return query.get();
  }
}

class LineItem {
  final String dishName;
  final int quantity;
  final double price;

  const LineItem({
    required this.dishName,
    required this.quantity,
    required this.price,
  });
}
