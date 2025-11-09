import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnote_app/component/note_tile.dart';

void main() {
  testWidgets('NoteTile muncul dan menampilkan title serta content dengan benar', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteTile(
            title: 'Catatan Uji',
            content: 'Ini isi catatan untuk pengujian.',
            onEditPressed: () {},
            onDeletePressed: () {},
          ),
        ),
      ),
    );

    expect(find.byType(NoteTile), findsOneWidget);

    expect(find.text('Catatan Uji'), findsOneWidget);

    expect(find.text('Ini isi catatan untuk pengujian.'), findsOneWidget);

    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
