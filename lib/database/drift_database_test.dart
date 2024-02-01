import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:flutter_pos/database/drift_database.dart';

class TestingDriftDB extends DriftDB {
  TestingDriftDB()
      : super.forTesting(
          DatabaseConnection.delayed(backgroundMemoryDB()),
        );

  @override
  MigrationStrategy get migration => MigrationStrategy();

  @override
  int get schemaVersion => 1;

  static Future<DatabaseConnection> backgroundMemoryDB() async {
    final isolate = await DriftIsolate.spawn(() {
      return DatabaseConnection(NativeDatabase.memory());
    });
    return isolate.connect(singleClientMode: true);
  }
}
