import 'package:flutter/material.dart';
import 'package:focusnote_app/component/drawer.dart';
import 'package:focusnote_app/component/navbar.dart';
import 'package:focusnote_app/component/task_tile.dart';
import 'package:focusnote_app/model/task_database.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readTasks();
  }

  // CREATE TASK
  void _createTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Task"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter task title..."),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<TaskDatabase>().addTask(textController.text);

              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // READ TASKS
  void _readTasks() {
    context.read<TaskDatabase>().readTasks();
  }

  // UPDATE TASK
  void _updateTask(Task task) { // Changed from TasksData to Task
    textController.text = task.title;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Update task title..."),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<TaskDatabase>()
                  .updateTask(task.id, textController.text);

              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // DELETE TASK
  void _deleteTask(int id) {
    context.read<TaskDatabase>().deleteTask(id);
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final taskDatabase = context.watch<TaskDatabase>();

    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 1),
      appBar: AppBar(
        title: const Text("Tasks"),
        elevation: 10,
        backgroundColor: const Color.fromARGB(0, 212, 192, 192),
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(size: 30),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      // BUTTON ADD TASK
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0, right: 10.0),
        child: FloatingActionButton(
          onPressed: _createTask,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),

      endDrawer: const MyDrawer(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10),
            child: Text(
              'Tasks',
              style: GoogleFonts.dmSerifText(
                fontSize: 50,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // LIST TASKS
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: taskDatabase.currentTasks.length + 1,
              itemBuilder: (context, index) {
                if (index < taskDatabase.currentTasks.length) {
                  final task = taskDatabase.currentTasks[index];
                  return TaskTile(
                    text: task.title,
                    isCompleted: task.isCompleted,
                    onEditPressed: () => _updateTask(task),
                    onDeletePressed: () => _deleteTask(task.id),
                    onCheckboxChanged: (value) {
                      context
                          .read<TaskDatabase>()
                          .updateCompletion(task.id, value ?? false);
                    },
                  );
                } 
                else {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, top: 20, bottom: 20),
                    child: Text(
                      'Completed',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}