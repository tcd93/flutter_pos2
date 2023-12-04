import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/p2p/channel.dart';

class InvalidJsonFormatException extends FormatException {
  final String cause;

  InvalidJsonFormatException([String? cause])
      : this.cause = cause ?? 'Invalid json format';
}

class Syncer {
  static Syncer? instance;
  late Profile type;

  factory Syncer({required Profile type}) {
    instance ??= Syncer._(type);
    return instance!;
  }

  Syncer._(this.type);

  /// Process and persist messages into database, return rowcount
  Future<int?> sync(Profile type, DriftDB db, dynamic json) async {
    // role changed since singleton instance creation, ignore
    if (type != this.type) {
      return null;
    }
    final trans = _tryUnwrap(json);
    if (trans == null) return null;

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

    return null;
  }

  List<Insertable>? _tryUnwrap(dynamic json) {
    final recordType = json['record_type'];
    List<dynamic> records = json['record_details'];
    if (records.isEmpty)
      throw InvalidJsonFormatException('record_details contains empty list');

    switch (recordType) {
      case 'Transaction':
        return records.map((r) => Transaction.fromJson(r)).toList();
      default:
        throw 'Sync type ${recordType} not supported';
    }
  }

  /// total number of rows we should process
  static int getCount(dynamic json) {
    if (json['total_size'] == null)
      throw InvalidJsonFormatException('no total_size found in json message');
    return json['total_size'];
  }

  static String getType(dynamic json) {
    if (json['record_type'] == null)
      throw InvalidJsonFormatException('no record_type found in json message');
    return json['record_type'];
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
