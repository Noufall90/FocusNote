import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focusnote_app/database/task/task_database.dart';
import 'package:focusnote_app/database/notes/note_database.dart';
import 'package:focusnote_app/pages/note_page.dart';
import 'package:focusnote_app/pages/stat_page.dart';
import 'package:focusnote_app/pages/task_page.dart';
import 'package:focusnote_app/tema/theme_provide.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskDatabase()),
        ChangeNotifierProvider(create: (_) => NoteDatabase()),
        ChangeNotifierProvider(create: (_) => ThemeProvide()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final themeProvider = context.watch<ThemeProvide>();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themeData,
          initialRoute: '/task',
          routes: {
            '/task': (context) => const TaskPage(),
            '/note': (context) => const NotePage(),
            '/stat': (context) => const StatPage(),
          },
        );
      },
    );
  }
}
