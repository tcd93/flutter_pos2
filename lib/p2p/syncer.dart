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
    final trx = _tryUnwrap(message);
    if (trx == null) return;

    if (trx is Transaction) {
      return db.into(db.transactions).insertOnConflictUpdate(trx);
    }
  }

  String wrap(DataClass data) {
    final type = data.runtimeType.toString();
    return jsonEncode({
      'record_type': type,
      'record_details': data.toJson(),
    });
  }

  DataClass? _tryUnwrap(String message) {
    try {
      final json = jsonDecode(message);
      final recordType = json['record_type'];
      final record = json['record_details'];
      switch (recordType) {
        case 'Transaction':
          return Transaction.fromJson(record);
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
