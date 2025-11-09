// lib/database/task/task_database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';

// Untuk mendapatkan lokasi database
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// === Import Task ===
import 'tables/tasks.dart';
import 'task_dao.dart';

// === Import Notes ===
import 'package:focusnote_app/database/notes/tables/notes.dart';
import 'package:focusnote_app/database/notes/note_dao.dart';

part 'task_database.g.dart';

// =====================================================
@DriftDatabase(tables: [Tasks, Notes], daos: [TaskDao, NoteDao])
class TaskDatabase extends _$TaskDatabase with ChangeNotifier {
  TaskDatabase() : super(_openConnection());

  TaskDatabase.inMemory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  // === TASKS ===
  List<Task> _currentTasks = [];
  List<Task> get currentTasks => _currentTasks;
  TaskDao get task => taskDao;

  // === NOTES ===
  List<Note> _currentNotes = [];
  List<Note> get currentNotes => _currentNotes;
  NoteDao get note => noteDao;

  // --- TASK METHODS ---
  Future<void> readTasks() async {
    _currentTasks = await task.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    await task.addTask(title);
    await readTasks();
  }

  Future<void> updateTask(int id, String newTitle) async {
    await task.updateTask(id, newTitle);
    await readTasks();
  }

  Future<void> updateCompletion(int id, bool isCompleted) async {
    await task.updateCompletion(id, isCompleted);
    await readTasks();
  }

  Future<void> deleteTask(int id) async {
    await task.deleteTask(id);
    await readTasks();
  }

  Future<void> deleteCompletedTasks() async {
    await task.deleteCompletedTasks();
    await readTasks();
  }

  // --- NOTE METHODS ---
  Future<void> readNotes() async {
    _currentNotes = await note.getAllNotes();
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    await note.addNote(title, content);
    await readNotes();
  }

  Future<void> updateNote(int id, String newTitle, String newContent) async {
    await note.updateNote(id, newTitle, newContent);
    await readNotes();
  }

  Future<void> deleteNote(int id) async {
    await note.deleteNote(id);
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
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'focusnote.sqlite'));
    return NativeDatabase(file);
  });
}
