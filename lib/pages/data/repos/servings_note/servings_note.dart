import 'package:drift/drift.dart';
import 'package:flutter_pos/database/drift_database.dart';
import 'package:flutter_pos/pages/data/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'servings_note.g.dart';

// final _logger = Logger('Servings Note Repo');

@riverpod
class Note extends _$Note {
  @override
  Future<String?> build(int cardID) async {
    final db = ref.read(dbProvider);
    final query = db.selectOnly(db.servingsNote)
      ..addColumns([db.servingsNote.note])
      ..where(db.servingsNote.cardID.equals(cardID));
    return query.map((row) => row.read(db.servingsNote.note)).getSingleOrNull();
  }

  Future<dynamic> takeNote(String note) async {
    state = AsyncData(note);
    return _updateSource();
  }

  Future<dynamic> _updateSource() {
    final db = ref.read(dbProvider);
    return db.into(db.servingsNote).insertOnConflictUpdate(
          ServingsNoteCompanion.insert(
            cardID: Value(cardID),
            note: Value(state.value),
          ),
        );
  }
}
