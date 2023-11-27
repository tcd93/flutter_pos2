import 'dart:async';

import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/status.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show DateTimeRange, DateUtils;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'controls.dart';
part 'db.g.dart';
part 'repository.dart';

@Riverpod(keepAlive: true)
DriftDB _db(_DbRef _) => DriftDB();
