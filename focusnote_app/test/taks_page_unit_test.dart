import 'package:flutter_test/flutter_test.dart';
import 'package:focusnote_app/database/task/task_database.dart';

void main() {
  late TaskDatabase database;

  setUp(() {
    database = TaskDatabase.inMemory();
  });

  tearDown(() async {
    await database.close();
  });

  test('Create Task with time & read tasks', () async {
    await database.addTask("Belajar Flutter", time: "10:30");

    expect(database.currentTasks.length, 1);
    expect(database.currentTasks.first.title, "Belajar Flutter");
    expect(database.currentTasks.first.time, "10:30");
  });

  test('Update Task title', () async {
    await database.addTask("Old Title", time: "08:00");
    final taskId = database.currentTasks.first.id;

    await database.updateTask(taskId, "New Title");

    expect(database.currentTasks.first.title, "New Title");
  });

  test('Update Task completion status', () async {
    await database.addTask("Selesaiin UI", time: "15:00");
    final taskId = database.currentTasks.first.id;

    await database.updateCompletion(taskId, true);

    expect(database.currentTasks.first.isCompleted, true);
  });

  test('Delete Task', () async {
    await database.addTask("Hapus Aku", time: "09:00");
    final taskId = database.currentTasks.first.id;

    await database.deleteTask(taskId);

    expect(database.currentTasks.isEmpty, true);
  });
}
