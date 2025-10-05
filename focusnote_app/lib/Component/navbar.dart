import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  const NavBar({super.key, required this.selectedIndex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: GNav(
        selectedIndex: widget.selectedIndex,   // <- penting
        color: Colors.white,
        activeColor: Theme.of(context).colorScheme.inversePrimary,
        tabBackgroundColor: Theme.of(context).colorScheme.secondary,
        gap: 10,
        padding: const EdgeInsets.all(15),
        tabs: const [
          GButton(icon: Icons.edit_square, text: 'Note'),
          GButton(icon: Icons.home, text: 'Tasks'),
          GButton(icon: Icons.data_exploration, text: 'Statistik'),
        ],
        onTabChange: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/note');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/task');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/stat');
              break;
          }
        },
      ),
    );
  }
}
