import 'package:flutter/material.dart';
import 'package:focusnote_app/component/drawer.dart';
import 'package:focusnote_app/component/navbar.dart';
import 'package:focusnote_app/component/task_tile.dart';
import 'package:focusnote_app/database/task/task_database.dart';
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
        decoration: const InputDecoration(
          hintText: "Enter task title...",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              context.read<TaskDatabase>().addTask(textController.text);
              textController.clear();
              Navigator.pop(context);
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
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
  void _updateTask(Task task) { 
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
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/icon/logo_bar_putih.png' 
                    : 'assets/icon/logo_bar.png',  
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
         child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primary,
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
            child: Builder(
              builder: (context) {
                final allTasks = taskDatabase.currentTasks;
                final activeTasks = allTasks.where((t) => !t.isCompleted).toList();
                final completedTasks = allTasks.where((t) => t.isCompleted).toList();

                return ListView(
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    // --- ACTIVE TASKS ---
                    if (activeTasks.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "No active tasks",
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ...activeTasks.map((task) => TaskTile(
                            text: task.title,
                            isCompleted: task.isCompleted,
                            onEditPressed: () => _updateTask(task),
                            onDeletePressed: () => _deleteTask(task.id),
                            onCheckboxChanged: (value) {
                              context
                                  .read<TaskDatabase>()
                                  .updateCompletion(task.id, value ?? false);
                            },
                          )),

                    // COMPLETED SECTION TITLE 
                    if (completedTasks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                        child: Text(
                          "Completed",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),

                    // COMPLETED TASKS
                    ...completedTasks.map((task) => TaskTile(
                          text: task.title,
                          isCompleted: task.isCompleted,
                          onEditPressed: () => _updateTask(task),
                          onDeletePressed: () => _deleteTask(task.id),
                          onCheckboxChanged: (value) {
                            context
                                .read<TaskDatabase>()
                                .updateCompletion(task.id, value ?? false);
                          },
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );}
}