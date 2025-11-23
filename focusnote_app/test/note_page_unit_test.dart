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

  test('Create & Read Notes', () async {
    await database.addNote("Judul Pertama", "Isi 1");
    await database.addNote("Judul Kedua", "Isi 2");

    expect(database.currentNotes.length, 2);

    // Karena order by desc id → note terbaru ada di index 0
    expect(database.currentNotes.first.title, "Judul Kedua");
    expect(database.currentNotes.last.title, "Judul Pertama");
  });

  test('Update Note', () async {
    await database.addNote("Old", "Content Old");
    final noteId = database.currentNotes.first.id;

    await database.updateNote(noteId, "New Title", "New Content");

    expect(database.currentNotes.first.title, "New Title");
    expect(database.currentNotes.first.content, "New Content");
  });

  test('Delete Note', () async {
    await database.addNote("Will be Deleted", "bye");
    final id = database.currentNotes.first.id;

    await database.deleteNote(id);

    expect(database.currentNotes.isEmpty, true);
  });

  test('Delete empty content notes only', () async {
    await database.addNote("Note Kosong", '');
    await database.addNote("Note Ada Isi", "Hello");

    expect(database.currentNotes.length, 2);

    await database.note.deleteEmptyNotes();
    await database.readNotes();

    expect(database.currentNotes.length, 1);
    expect(database.currentNotes.first.content, "Hello");
  });
}
