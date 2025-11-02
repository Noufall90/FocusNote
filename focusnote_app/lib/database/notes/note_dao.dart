// lib/database/notes/note_dao.dart
import 'package:drift/drift.dart';
import 'package:focusnote_app/database/task/task_database.dart';
import 'tables/notes.dart';

part 'note_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NoteDao extends DatabaseAccessor<TaskDatabase> with _$NoteDaoMixin {
  NoteDao(super.db);

  // CREATE
  Future<void> addNote(String title, [String content = '']) async {
    await into(notes).insert(NotesCompanion(
      title: Value(title),
      content: Value(content),
    ));
  }

  // READ
  Future<List<Note>> getAllNotes() =>
      (select(notes)..orderBy([(t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc)])).get();

  // UPDATE
  Future<void> updateNote(int id, String newTitle, String newContent) async {
    await (update(notes)..where((n) => n.id.equals(id))).write(
      NotesCompanion(
        title: Value(newTitle),
        content: Value(newContent),
      ),
    );
  }

  // DELETE
  Future<void> deleteNote(int id) async {
    await (delete(notes)..where((n) => n.id.equals(id))).go();
  }

  // Opsional: hapus note kosong
  Future<void> deleteEmptyNotes() async {
    await (delete(notes)..where((n) => n.content.equals(''))).go();
  }
}
