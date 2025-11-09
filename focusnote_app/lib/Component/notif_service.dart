import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class NotifService {
  static final NotifService _instance = NotifService._internal();
  factory NotifService() => _instance;
  NotifService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool _isNotificationEnabled = true; // Default to enabled, but load from prefs

  bool get isInitialized => _isInitialized;
  bool get isNotificationEnabled => _isNotificationEnabled;

  // Load notification status from SharedPreferences
  Future<void> _loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool('notification_enabled') ?? true;
  }

  // Save notification status to SharedPreferences
  Future<void> _saveNotificationStatus(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', enabled);
    _isNotificationEnabled = enabled;
  }

  // INITIALIZE
  Future<void> initNotifications() async {
    if (_isInitialized) return;

    // Load status first
    await _loadNotificationStatus();

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    // Request permissions
    final androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  // DETAIL
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'focusnote_channel',
        'FocusNote Notifications',
        channelDescription: 'Channel for FocusNote app notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  // TOGGLE NOTIFICATIONS
  Future<void> toggleNotifications(bool enabled) async {
    await _saveNotificationStatus(enabled);
    if (!enabled) {
      // Cancel all notifications if disabled
      await notificationsPlugin.cancelAll();
    }
  }

  // SHOW NOTIFICATION (only if enabled)
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    if (!_isNotificationEnabled) return; // Don't show if disabled

    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }
}