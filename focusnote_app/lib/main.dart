import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focusnote_app/database/task/task_database.dart';
import 'package:focusnote_app/tema/theme_provide.dart';
import 'package:focusnote_app/component/notif_service.dart';
import 'package:focusnote_app/pages/task_page.dart';
import 'package:focusnote_app/pages/note_page.dart';
import 'package:focusnote_app/pages/stat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotifService().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskDatabase()),
        ChangeNotifierProvider(create: (_) => ThemeProvide()),
      ],
      
      child: Consumer<ThemeProvide>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FocusNote',
            theme: themeProvider.themeData,

            // Halaman pertama yang dibuka
            initialRoute: '/task',

            // Routing ke semua halaman
            routes: {
              '/task': (context) => const TaskPage(),
              '/note': (context) => const NotePage(),
              '/stat': (context) => const StatPage(),
            },
          );
        },
      ),
    );
  }
}
