import 'package:flutter/material.dart';
import 'package:focusnote_app/component/drawer.dart';
import 'package:focusnote_app/component/navbar.dart';
import 'package:focusnote_app/component/note_tile.dart';
import 'package:focusnote_app/database/task/task_database.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readNotes();
  }

  // CREATE 
  void _createNote() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Enter note title..."),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: "Enter note content..."),
              maxLines: 3,
            ),
          ],
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
              if (titleController.text.isNotEmpty) {
                context.read<TaskDatabase>().addNote(
                      titleController.text,
                      contentController.text,
                    );
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

  // READ 
  void _readNotes() {
    context.read<TaskDatabase>().readNotes();
  }

  // UPDATE 
  void _updateNote(Note note) { 
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Update note title..."),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: "Update note content..."),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<TaskDatabase>().updateNote(
                      note.id,
                      titleController.text,
                      contentController.text,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // DELETE 
  void _deleteNote(int id) {
    context.read<TaskDatabase>().deleteNote(id);
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<TaskDatabase>();

       return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 0),
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

      // BUTTON ADD 
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0, right: 10.0),
        child: FloatingActionButton(
          onPressed: _createNote,
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
              'Notes',
              style: GoogleFonts.dmSerifText(
                fontSize: 50,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          // LIST 
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: noteDatabase.currentNotes.length,
              itemBuilder: (context, index) {
                final note = noteDatabase.currentNotes[index];
                return NoteTile(
                  title: note.title,        // judul
                  content: note.content,    // deskripsi
                  onEditPressed: () => _updateNote(note),
                  onDeletePressed: () => _deleteNote(note.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}