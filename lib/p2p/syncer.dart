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

  Future<dynamic> sync(Profile type, DriftDB db, String message) async {
    // role changed since singleton instance creation, ignore
    if (type != this.type) {
      return;
    }
    final trans = _tryUnwrap(message);
    if (trans == null) return;

    if (trans is List<Insertable<Transaction>>) {
      return db.transactions.insertAll(
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
    }
  }

  String wrap(Iterable<Insertable> data) {
    assert(data.isNotEmpty);
    final type = data.first.runtimeType.toString();
    return jsonEncode({'record_type': type, 'record_details': data});
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
}
