import 'package:flutter/material.dart';
import 'package:focusnote_app/Model/note.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // DATABASE
  static Future<void> initialize() async 
  {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }
  
  // LIST NOTE
  final List<Note> currentNote = [];

  // CREATE
  Future<void> addNote(String text) async 
  {
    // new note object
    final newNote = Note()..text = text; // pakai cascade operator

    // save to db
    await isar.writeTxn(() => isar.notes.put(newNote));
    await readNote();
  }

  // READ
  Future<void> readNote() async {
    final readNotes = await isar.notes.where().findAll();
    // current note add to below code
    currentNote
      ..clear()
      ..addAll(readNotes);
      notifyListeners();
  }

  // UPDATE
  Future<void> updateNote(int id, String newText) async 
  {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await readNote();
    }
  }

  // DELETE
  Future<void> deleteNote(int id) async 
  {
    await isar.writeTxn(() => isar.notes.delete(id));
    await readNote();
  }
}
