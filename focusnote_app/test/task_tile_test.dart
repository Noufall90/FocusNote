import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnote_app/component/task_tile.dart';

void main() {
  testWidgets('TaskTile muncul dengan benar dan menampilkan teks serta checkbox',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskTile(
            text: 'Test Task',
            isCompleted: false,
            onEditPressed: () {},
            onDeletePressed: () {},
            onCheckboxChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(TaskTile), findsOneWidget);

    expect(find.text('Test Task'), findsOneWidget);

    expect(find.byType(Checkbox), findsOneWidget);

    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
