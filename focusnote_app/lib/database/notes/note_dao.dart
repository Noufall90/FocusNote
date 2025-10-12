// lib/database/note_dao.dart
import 'package:drift/drift.dart';
import 'package:focusnote_app/database/notes/note_database.dart';
import 'package:focusnote_app/database/notes/tables/notes.dart';

part 'note_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NoteDao extends DatabaseAccessor<NoteDatabase> with _$NoteDaoMixin {
  NoteDao(super.db);

  // CREATE
  Future<void> addNote(String title, [String content = '']) async {
    await into(notes).insert(
      NotesCompanion.insert(title: title, content: Value(content)),
    );
  }

  // READ
  Future<List<Note>> getAllNotes() => select(notes).get();

  // UPDATE
  Future<void> updateNote(int id, String title, [String? content]) async {
    await (update(notes)..where((t) => t.id.equals(id))).write(
      NotesCompanion(
        title: Value(title),
        content: content != null ? Value(content) : const Value.absent(),
      ),
    );
  }

  // DELETE
  Future<void> deleteNote(int id) async {
    await (delete(notes)..where((t) => t.id.equals(id))).go();
  }
}
