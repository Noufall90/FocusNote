import 'package:flutter/material.dart';
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

  // create note
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
              // add to db
              context.read<NoteDatabase>().addNote(textController.text);

              // clear text
              textController.clear();

              // pop dialog box
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


  @override
  Widget build(BuildContext context) 
  {
    final noteDatabase = context.watch<NoteDatabase>();

    return Scaffold
    (
      appBar: AppBar
      (
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      // BUTTON ADD NOTE
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 10.0), // jarak dari bawah
        child: FloatingActionButton(
          onPressed: createNote,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      drawer: Drawer(),
      body: Column
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: 
        [
          // HEADING
          Padding
          (
            padding: const EdgeInsets.only(left: 20.0),
            child: Text('Notes', style: GoogleFonts.dmSerifText
            (
              fontSize : 48,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            ),
          ),



          // LIST NOTE
          Expanded
          (
            child: ListView.builder
            (
              itemCount: noteDatabase.currentNote.length,
              itemBuilder: (context, index) 
              {
                final note = noteDatabase.currentNote[index];

                return ListTile
                (
                  title: Text(note.text),
                  trailing: Row
                  (
                    mainAxisSize: MainAxisSize.min,
                    children: 
                    [
                      // edit button
                      IconButton
                      (
                        onPressed: () => updateNote(note), 
                        icon: const Icon(Icons.edit),
                      ),

                      // delete button
                      IconButton
                      (
                        onPressed: () => deleteNote(note.id), 
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            )
          )
        ],
      ),
    );
  }
}
