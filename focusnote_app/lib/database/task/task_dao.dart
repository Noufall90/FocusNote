import 'package:drift/drift.dart';
import 'package:focusnote_app/database/task/task_database.dart';
import 'package:focusnote_app/database/task/tables/tasks.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks])
class TaskDao extends DatabaseAccessor<TaskDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  // CREATE - dengan waktu
  Future<void> addTask(String title, {String? time}) async {
    await into(tasks).insert(TasksCompanion.insert(
      title: title,
      time: Value(time),
    ));
  }

  // READ
  Future<List<Task>> getAllTasks() => select(tasks).get();

  // UPDATE
  Future<void> updateTask(int id, String newTitle) async {
    await (update(tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(title: Value(newTitle)));
  }

  // UPDATE COMPLETION
  Future<void> updateCompletion(int id, bool isCompleted) async {
    await (update(tasks)..where((t) => t.id.equals(id)))
        .write(TasksCompanion(isCompleted: Value(isCompleted)));
  }

  // DELETE
  Future<void> deleteTask(int id) async {
    await (delete(tasks)..where((t) => t.id.equals(id))).go();
  }

  // DELETE semua task yang sudah selesai
  Future<void> deleteCompletedTasks() async {
    await (delete(tasks)..where((t) => t.isCompleted.equals(true))).go();
  }
}