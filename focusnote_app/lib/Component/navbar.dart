import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: GNav(
        color: Colors.white,
        activeColor: Theme.of(context).colorScheme.inversePrimary,
        tabBackgroundColor: Theme.of(context).colorScheme.secondary,
        gap: 5,
        padding: const EdgeInsets.all(15),
        tabs: const [
          GButton(
            icon: Icons.edit_square, 
            text: 'Note'),
          GButton(
            icon: Icons.home, 
            text: 'Tasks'),
          GButton(
            icon: Icons.data_exploration, 
            text: 'Data'),
        ],
      ),
    );
  }
}
