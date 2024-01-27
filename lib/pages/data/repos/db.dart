import 'package:flutter_pos/database/drift_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db.g.dart';

@Riverpod(keepAlive: true)
DriftDB db(DbRef _) => DriftDB();
