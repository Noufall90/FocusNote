import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:focusnote_app/Pages/task_page.dart';
import 'package:focusnote_app/Pages/note_page.dart';
import 'package:focusnote_app/Pages/stat_page.dart';

class AppRouter {
  static GoRouter createRouter() {
    return GoRouter(
      initialLocation : "/",
      routes: [
        GoRoute(
          path: "/",
          name: "task",
          builder: (ctx, st) => const TaskPage(),
        ),
        GoRoute(
          path: "/",
          name: "note",
          builder: (ctx, st) => const NotePage(),
        ),
        GoRoute(
          path: "/",
          name: "stat",
          builder: (ctx, st) => const StatPage(),
        ),
      ],
      errorBuilder: (ctx, st) => Scaffold(
        appBar: AppBar(title: const Text("Not found")),
        body: const Center(child: Text("Halaman tidak ketemu"),),
      )
    );
  }
}