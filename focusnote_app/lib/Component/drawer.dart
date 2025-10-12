import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:focusnote_app/component/drawer_tile.dart';
import 'package:focusnote_app/tema/theme_provide.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget
{
  const MyDrawer({super.key});

  @override
  Widget build (BuildContext context)
  {
    return Drawer
    (
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column
      (
        children: 
        [
          // HEADER
          DrawerHeader
          (
            child: Icon(
              Icons.settings_applications,
              size: 40,),
          ),

// DARK MODE
          DrawerTile
          (
            title: "Dark Mode",
            leading: const Icon(
              Icons.dark_mode,
              size: 30,),
            onTap: () {},
            trailing: Consumer<ThemeProvide>(
              builder: (context, themeProvider, child) => CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}