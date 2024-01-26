import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:logging/logging.dart';

final _logger = Logger('Syncer');

class InvalidJsonFormatException extends FormatException {
  final String cause;

  InvalidJsonFormatException([String? cause])
      : cause = cause ?? 'Invalid json format';
}

class Syncer {
  final DriftDB db;

  Syncer(this.db);

  String getType(dynamic json) {
    if (json['record_type'] == null)
      throw InvalidJsonFormatException('no record_type found in json message');
    return json['record_type'];
  }

  /// When Transaction batch processing is complete, [onTransactionSyncComplete] is called
  /// When the receiving end done processing Transactions, [onAcknowledge] is called
  void processMessage(
    String message, {
    required void Function() onTransactionSyncComplete,
    required void Function() onAcknowledge,
  }) async {
    try {
      final json = jsonDecode(message);
      final type = getType(json);

      switch (type) {
        case 'Transaction':
          await syncTransactions(json);
          final done = json['done'];
          if (done) onTransactionSyncComplete();
        case 'Acknowledge':
          onAcknowledge();
      }
    } on InvalidJsonFormatException catch (ex) {
      _logger.severe(ex);
    } on FormatException catch (ex, stack) {
      _logger.severe('Error in json decoding', ex, stack);
    } catch (ex, stack) {
      _logger.severe('Unknown error', ex, stack);
    }
  }

  /// Process and persist messages into database, return rowcount
  @visibleForTesting
  Future<int?> syncTransactions(dynamic json) async {
    final trans = _tryUnwrap<Transaction>(json);

    await db.transactions.insertAll(
      trans,
      onConflict: DoUpdate.withExcluded(
        (old, excluded) {
          return TransactionsCompanion.custom(
            cardID: excluded.cardID,
            date: excluded.date,
            time: excluded.time,
            price: excluded.price,
            note: (excluded.note + const Constant(' -merged'))
                .iif(excluded.note.isNotNull(), excluded.note),
          );
        },
        target: [db.transactions.date, db.transactions.time],
      ),
    );
    return trans.length;
  }

  List<T> _tryUnwrap<T>(dynamic json) {
    List<dynamic> records = json['record_details'];
    if (records.isEmpty)
      throw InvalidJsonFormatException('record_details contains empty list');

    // if generic type support factory methods that would be great
    // https://github.com/dart-lang/language/issues/356
    if (T == Transaction) {
      return records.map((r) => Transaction.fromJson(r)).toList() as List<T>;
    }
    throw 'Sync type ${T.runtimeType} not supported';
  }

  static String acknowledge() {
    return jsonEncode({'record_type': 'Acknowledge'});
  }

  /// [totalSize] > [data.length] then it is part of a batched transfer
  static String wrap(Iterable<Insertable> data, [bool done = true]) {
    assert(data.isNotEmpty);

    final type = data.first.runtimeType.toString();
    return jsonEncode(
      {'record_type': type, 'done': done, 'record_details': data},
    );
  }

  /// wrap 10 transactions at a time
  static Stream<String> wrapTen(List<Insertable> data) async* {
    assert(data.isNotEmpty);
    for (int i = 0; i < data.length; i = i + 10) {
      int j = i + 10;
      if (j >= data.length) j = data.length;

      yield wrap(data.sublist(i, j), j == data.length);
    }
  }
}
