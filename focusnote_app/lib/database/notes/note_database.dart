// lib/database/note_database.dart
import 'dart:async';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

import 'tables/notes.dart';
import 'note_dao.dart';

part 'note_database.g.dart';

@DriftDatabase(tables: [Notes], daos: [NoteDao])
class NoteDatabase extends _$NoteDatabase with ChangeNotifier {
  NoteDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  List<Note> currentNotes = [];

  final _daoReady = Completer<bool>();

  Future<void> initDao() async {
    if (!_daoReady.isCompleted) _daoReady.complete(true);
  }

  NoteDao get dao => noteDao;

  // READ untuk sinkronisasi UI
  Future<void> readNotes() async {
    currentNotes = await dao.getAllNotes();
    notifyListeners();
  }

  // Proxy ke DAO agar NotePage tidak perlu diubah banyak
  Future<void> addNote(String title, [String content = '']) async {
    await dao.addNote(title, content);
    await readNotes();
  }

  Future<void> updateNote(int id, String title, [String? content]) async {
    await dao.updateNote(id, title, content);
    await readNotes();
  }

  Future<void> deleteNote(int id) async {
    await dao.deleteNote(id);
    await readNotes();
  }

  @override
  Future<void> close() {
    notifyListeners();
    return super.close();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notes.sqlite'));
    return NativeDatabase(file);
  });
}
