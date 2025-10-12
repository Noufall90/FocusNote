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
      bottomNavigationBar: const NavBar(selectedIndex: 2),
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/icon/logo_bar_putih.png' 
                    : 'assets/icon/logo_bar.png',  
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 10,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: const IconThemeData(size: 30),
      ),
      
      backgroundColor: Theme.of(context).colorScheme.surface,
      endDrawer: const MyDrawer(),
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
