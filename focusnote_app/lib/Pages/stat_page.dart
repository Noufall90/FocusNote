import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:focusnote_app/component/drawer.dart';
import 'package:focusnote_app/component/navbar.dart';

class StatPage extends StatefulWidget{
  const StatPage({super.key});

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      // DRAWER
      endDrawer: const MyDrawer(),

      // NAVBAR
      bottomNavigationBar: NavBar(selectedIndex: 2),
      appBar: AppBar
      (
        title: const Text("Statistik"),
        elevation: 10,
        backgroundColor: const Color.fromARGB(0, 212, 192, 192),
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: IconThemeData(size: 30),
      ),
      
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 0),
            child: Text(
              'Statistik',
              style: GoogleFonts.dmSerifText(
                fontSize: 50,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
