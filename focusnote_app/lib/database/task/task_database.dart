import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/tasks.dart';
import 'task_dao.dart';

part 'task_database.g.dart';

@DriftDatabase(tables: [Tasks], daos: [TaskDao])
class TaskDatabase extends _$TaskDatabase with ChangeNotifier {
  TaskDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  List<Task> currentTasks = [];

  TaskDao get dao => taskDao;

  // READ
  Future<void> readTasks() async {
    currentTasks = await dao.getAllTasks();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    await dao.addTask(title);
    await readTasks();
  }

  Future<void> updateTask(int id, String newTitle) async {
    await dao.updateTask(id, newTitle);
    await readTasks();
  }

  Future<void> updateCompletion(int id, bool isCompleted) async {
    await dao.updateCompletion(id, isCompleted);
    await readTasks();
  }

  Future<void> deleteTask(int id) async {
    await dao.deleteTask(id);
    await readTasks();
  }

  Future<void> deleteCompletedTasks() async {
    await dao.deleteCompletedTasks();
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
