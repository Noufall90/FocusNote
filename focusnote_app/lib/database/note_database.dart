import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

part 'note_database.g.dart';

// ===== TABLE =====
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get content => text().named('content').withDefault(const Constant(''))();
  // Remove DateTime columns for now to avoid issues
}

// ===== DATABASE =====
@DriftDatabase(tables: [Notes])
class NoteDatabase extends _$NoteDatabase with ChangeNotifier {
  NoteDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Cache list untuk UI
  List<Note> currentNotes = [];

  // CREATE
  Future<void> addNote(String title, [String content = '']) async {
    await into(notes).insert(
      NotesCompanion.insert(
        title: title,
        content: Value(content),
      ),
    );
    await readNotes();
  }

  // READ semua note
  Future<void> readNotes() async {
    final allNotes = await select(notes).get();
    currentNotes
      ..clear()
      ..addAll(allNotes);
    notifyListeners();
  }

  // UPDATE note
  Future<void> updateNote(int id, String newTitle, [String? newContent]) async {
    await (update(notes)..where((tbl) => tbl.id.equals(id))).write(
      NotesCompanion(
        title: Value(newTitle),
        content: newContent != null ? Value(newContent) : const Value.absent(),
      ),
    );
    await readNotes();
  }

  // DELETE note
  Future<void> deleteNote(int id) async {
    await (delete(notes)..where((tbl) => tbl.id.equals(id))).go();
    await readNotes();
  }

  @override
  Future<void> close() {
    notifyListeners();
    return super.close();
  }
}

// ===== CONNECTION =====
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notes.sqlite'));
    return NativeDatabase(file);
  });
}