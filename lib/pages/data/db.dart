import 'dart:async';

import 'package:flutter/material.dart' show DateTimeRange, DateUtils;
import 'package:flutter_pos/database/drift_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db.g.dart';
part 'repository.dart';

@Riverpod(keepAlive: true)
DriftDB db(DbRef _) => DriftDB();
