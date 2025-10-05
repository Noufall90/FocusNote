import 'package:flutter/material.dart';
import 'package:focusnote_app/Model/task_database.dart';
import 'package:focusnote_app/Tema/theme_provide.dart';
import 'package:provider/provider.dart';
import 'Pages/task_page.dart';
import 'Pages/note_page.dart';
import 'Pages/stat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvide()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.watch<ThemeProvide>().themeData,

      // Halaman pertama yang dibuka
      initialRoute: '/task',

      // Daftar halaman
      routes: {
        '/task': (context) => const TaskPage(),
        '/note': (context) => const NotePage(),
        '/stat': (context) => const StatPage(),
      },
    );
  }
}

