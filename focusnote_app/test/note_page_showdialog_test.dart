// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:focusnote_app/Pages/note_page.dart';
import 'package:focusnote_app/database/task/task_database.dart';

void main() {
  testWidgets('Menampilkan dialog Create Note ketika tombol tambah ditekan',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<TaskDatabase>(
        create: (_) => TaskDatabase.inMemory(),
        child: const MaterialApp(home: NotePage()),
      ),
    );

    expect(find.byType(NotePage), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    expect(find.text('Create Note'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(2)); // Title dan Content
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Create Note'), findsOneWidget);
  });
}