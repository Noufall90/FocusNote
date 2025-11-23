import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class NotifService {
  static final NotifService _instance = NotifService._internal();
  factory NotifService() => _instance;
  NotifService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool _isNotificationEnabled = true;

  bool get isInitialized => _isInitialized;
  bool get isNotificationEnabled => _isNotificationEnabled;

  Future<void> _loadNotificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool('notification_enabled') ?? true;
  }

  Future<void> _saveNotificationStatus(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', enabled);
    _isNotificationEnabled = enabled;
  }

  // INITIALIZE
  Future<void> initNotifications() async {
    if (_isInitialized) return;

    // TIMEZONE
    tz.initializeTimeZones();
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final locationName = currentTimeZone.toString().split(',')[0].replaceAll('TimezoneInfo(', '');
    tz.setLocalLocation(tz.getLocation(locationName));

    await _loadNotificationStatus();

    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    // Request permissions
    final androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission(); 
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

  // SHOW NOTIFICATION 
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    if (!_isNotificationEnabled) return; 

    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }

  // SCHEDULE NOTIFICATION
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    if (!_isNotificationEnabled) return; // Tambahkan check ini

    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // SCHEDULE NOTIF
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Ubah ke exact untuk akurasi lebih baik
      matchDateTimeComponents: DateTimeComponents.time,
    );
    
    // ignore: avoid_print
    print('Scheduled notification for $scheduledDate');
  }

  Future<void> cancelAllNotification() async {
    await notificationsPlugin.cancelAll();
  }
}

