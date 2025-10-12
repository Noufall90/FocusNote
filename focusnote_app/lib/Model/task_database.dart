// lib/model/task_database.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';

part 'task_database.g.dart';

// ===== TABLE =====
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  // Remove createdAt for now to fix the issue
}

// ===== DATABASE =====
@DriftDatabase(tables: [Tasks])
class TaskDatabase extends _$TaskDatabase with ChangeNotifier {
  TaskDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Cached list for UI
  List<Task> currentTasks = [];

  // CREATE
  Future<void> addTask(String title) async {
    await into(tasks).insert(TasksCompanion.insert(title: title));
    await readTasks();
  }

  // READ
  Future<void> readTasks() async {
    final allTasks = await select(tasks).get();
    currentTasks
      ..clear()
      ..addAll(allTasks);
    notifyListeners();
  }

  // UPDATE title
  Future<void> updateTask(int id, String newTitle) async {
    await (update(tasks)..where((tbl) => tbl.id.equals(id)))
        .write(TasksCompanion(title: Value(newTitle)));
    await readTasks();
  }

  // UPDATE completion state
  Future<void> updateCompletion(int id, bool isCompleted) async {
    await (update(tasks)..where((tbl) => tbl.id.equals(id)))
        .write(TasksCompanion(isCompleted: Value(isCompleted)));
    await readTasks();
  }

  // DELETE
  Future<void> deleteTask(int id) async {
    await (delete(tasks)..where((tbl) => tbl.id.equals(id))).go();
    await readTasks();
  }

  // DELETE all completed tasks
  Future<void> deleteCompletedTasks() async {
    await (delete(tasks)..where((tbl) => tbl.isCompleted.equals(true))).go();
    await readTasks();
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
    final file = File(p.join(dir.path, 'tasks.sqlite'));
    return NativeDatabase(file);
  });
}