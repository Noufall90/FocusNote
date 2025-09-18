import 'package:flutter/material.dart';
import 'package:focusnote_app/Component/drawer.dart';
import 'package:focusnote_app/Component/navbar.dart';
import 'package:focusnote_app/Component/note_tile.dart';
import 'package:focusnote_app/Model/note.dart';
import 'package:focusnote_app/Model/note_database.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';


class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> 
{
  final textController = TextEditingController();

  @override
  void initState()
  {
    super.initState();

    readingNotes();
  }

// CREATE NOTE
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () 
            {
              context.read<NoteDatabase>().addNote(textController.text);

              // clear text
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }
  
// READ
  void readingNotes()
  {
    context.read<NoteDatabase>().readNote();
  }

// UPDATE NOTE
  void updateNote(Note note) {
    textController.text = note.text;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Note baru"),
        content: TextField(
          controller: textController,
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

// DELETE NOTE
  void deleteNote(int id)
  {
    context.read<NoteDatabase>().deleteNote(id);
  }

// UI
  @override
  Widget build(BuildContext context) 
  {
    final noteDatabase = context.watch<NoteDatabase>();

    return Scaffold
    (
      bottomNavigationBar: NavBar(),
      appBar: AppBar
      (
        elevation: 10,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: IconThemeData(size: 30),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      // BUTTON ADD NOTE
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0, right: 10.0), // jarak dari bawah
        child: FloatingActionButton(
          onPressed: createNote,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      drawer: MyDrawer(),
      body: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
// HEADING
          Padding
          (
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Tasks', style: GoogleFonts.dmSerifText
            (
              fontSize : 50,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            ),
          ),

// LIST NOTE
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: noteDatabase.currentNote.length + 1, 
              itemBuilder: (context, index) {
                if (index < noteDatabase.currentNote.length) {
                  final note = noteDatabase.currentNote[index];
                  return NoteTile(
                    text: note.text,
                    onEditPressed: () => updateNote(note),
                    onDeletPressed: () => deleteNote(note.id),
                  );
// BELOW NOTE
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20, bottom: 20),
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
