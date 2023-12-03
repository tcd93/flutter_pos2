import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/p2p/channel.dart';

class Syncer {
  static Syncer? instance;
  late Profile type;

  factory Syncer({required Profile type}) {
    instance ??= Syncer._(type);
    return instance!;
  }

  Syncer._(this.type);

  Future<int> sync(Profile type, DriftDB db, String message) async {
    // role changed since singleton instance creation, ignore
    if (type != this.type) {
      return -1;
    }
    final trans = _tryUnwrap(message);
    if (trans == null) return -1;

    if (trans is List<Insertable<Transaction>>) {
      await db.transactions.insertAll(
        trans,
        onConflict: DoUpdate.withExcluded(
          (old, excluded) {
            return TransactionsCompanion.custom(
              cardID: excluded.cardID,
              date: excluded.date,
              time: excluded.time,
              price: excluded.price,
              note: (excluded.note + Constant(' -merged'))
                  .iif(excluded.note.isNotNull(), excluded.note),
            );
          },
          target: [db.transactions.date, db.transactions.time],
        ),
      );
      return trans.length;
    }

    return -1;
  }

  List<Insertable>? _tryUnwrap(String message) {
    try {
      final json = jsonDecode(message);

      final recordType = json['record_type'];
      List<dynamic> records = json['record_details'];
      if (records.isEmpty) {
        throw 'record_details contains empty list';
      }

      switch (recordType) {
        case 'Transaction':
          return records.map((r) => Transaction.fromJson(r)).toList();
        default:
          throw 'Sync type ${recordType} not supported';
      }
    } catch (ex, stack) {
      print('Exception in json decoding: ${ex.toString()}');
      print(stack);
    }
    return null;
  }

  static int getSize(String message) {
    final json = jsonDecode(message);
    return json['total_size'];
  }

  /// [totalSize] > [data.length] then it is part of a batched transfer
  static String wrap(Iterable<Insertable> data, [int? totalSize]) {
    assert(data.isNotEmpty);
    if (totalSize == null) totalSize = data.length;

    final type = data.first.runtimeType.toString();
    return jsonEncode(
      {'record_type': type, 'total_size': totalSize, 'record_details': data},
    );
  }

  /// wrap 10 transactions at a time
  static Stream<String> wrapTen(List<Insertable> data) async* {
    assert(data.isNotEmpty);
    for (int i = 0; i < data.length; i = i + 10) {
      int j = i + 10;
      if (j >= data.length) j = data.length;

      yield wrap(data.sublist(i, j), data.length);
    }
  }
}
