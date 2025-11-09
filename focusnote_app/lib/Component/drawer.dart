import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:focusnote_app/component/drawer_tile.dart';
import 'package:focusnote_app/tema/theme_provide.dart';
import 'package:focusnote_app/component/notif_service.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late NotifService _notifService;

  @override
  void initState() {
    super.initState();
    _notifService = NotifService();
    _notifService.initNotifications(); // Ensure initialized
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(Icons.settings_applications, size: 40),
          ),

          // DARK MODE
          DrawerTile(
            title: "Dark Mode",
            leading: const Icon(Icons.dark_mode, size: 30),
            onTap: () {},
            trailing: Consumer<ThemeProvide>(
              builder: (context, themeProvider, child) => CupertinoSwitch(
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
          ),

          // NOTIFIKASI ON/OFF
          DrawerTile(
            title: "Notifikasi",
            leading: const Icon(Icons.notifications, size: 30),
            onTap: () {},
            trailing: CupertinoSwitch(
              value: _notifService.isNotificationEnabled,
              onChanged: (value) async {
                await _notifService.toggleNotifications(value);
                setState(() {}); // Refresh UI

                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? "Notifikasi diaktifkan"
                          : "Notifikasi dimatikan",
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),

          // TEST NOTIFIKASI
          DrawerTile(
            title: "Test Notification",
            leading: const Icon(Icons.notifications_active, size: 30),
            onTap: () async {
              if (_notifService.isNotificationEnabled) {
                await _notifService.showNotification(
                  title: "Test Notification",
                  body: "This is a test notification",
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notifikasi dikirim")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Notifikasi sedang dimatikan"),
                  ),
                );
              }
            },
            trailing: null,
          ),
        ],
      ),
    );
  }
}