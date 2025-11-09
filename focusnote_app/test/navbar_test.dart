// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnote_app/component/navbar.dart';

void main() {
  testWidgets('NavBar menampilkan tab dan navigasi bekerja', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NavBar(selectedIndex: 0)),
        routes: {
          '/note': (context) => Container(key: const Key('note')),
          '/task': (context) => Container(key: const Key('task')),
          '/stat': (context) => Container(key: const Key('stat')),
        },
      ),
    );

    expect(find.byType(NavBar), findsOneWidget);
    expect(find.text('Note'), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
    expect(find.text('Statistik'), findsOneWidget);

    await tester.tap(find.text('Tasks'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('task')), findsOneWidget);
  });

  testWidgets('NavBar dengan selectedIndex 1', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: NavBar(selectedIndex: 1))),
    );

    expect(find.byType(NavBar), findsOneWidget);
    expect(find.text('Tasks'), findsOneWidget);
  });
}