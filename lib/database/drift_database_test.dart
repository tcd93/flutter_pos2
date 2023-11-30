import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_pos/database/drift_database.dart';

@DriftDatabase(include: {'tables.drift'})
class TestingDriftDB extends DriftDB {
  TestingDriftDB() : super.forTesting(NativeDatabase.memory());

  @override
  MigrationStrategy get migration => MigrationStrategy();

  @override
  int get schemaVersion => 1;
}
