import 'package:flutter/material.dart';
import 'package:focusnote_app/component/drawer.dart';
import 'package:focusnote_app/component/navbar.dart';
import 'package:focusnote_app/component/note_tile.dart';
import 'package:focusnote_app/database/notes/note_database.dart';
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create Note"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter note title..."),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteDatabase>().addNote(textController.text);

              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // READ 
  void _readNotes() {
    context.read<NoteDatabase>().readNotes();
  }

  // UPDATE 
  void _updateNote(Note note) { 
    textController.text = note.title;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Update note title..."),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);

              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // DELETE 
  void _deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();

    return Scaffold(
      bottomNavigationBar: const NavBar(selectedIndex: 0),
      appBar: AppBar(
        title: const Text("Notes"),
        elevation: 10,
        backgroundColor: const Color.fromARGB(0, 212, 192, 192),
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
              itemCount: noteDatabase.currentNotes.length + 1,
              itemBuilder: (context, index) {
                if (index < noteDatabase.currentNotes.length) {
                  final note = noteDatabase.currentNotes[index];
                  return NoteTile(
                    text: note.title,
                    onEditPressed: () => _updateNote(note),
                    onDeletePressed: () => _deleteNote(note.id),
                    
                  );
                }
                return null; 
              },
            ),
          ),
        ],
      ),
    );
  }
}