import 'dart:async';
import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//local notification
  static Future localInit() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS Initialization
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);

    // Initialize the plugin
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationClick(details.payload);
      },
    );

    // Check if the app was launched from a notification (when terminated)
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      _handleNotificationClick(details!.notificationResponse?.payload);
    }

    // Request notification permission for Android
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<String> getInitNotif() async {
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp ?? false) {
      String? payload = details?.notificationResponse?.payload;
      return (payload == "0" ||
          payload == "-1" ||
          payload == "-2" ||
          payload!.startsWith("file://") ||
          payload.endsWith(".pdf") ||
          payload.endsWith(".jpg"))
          ? "dashboard"
          : "dashboard";
    }
    return "dashboard";
  }

  static Future<void> cancelAllExceptSome(List<int> exceptIds) async {
    final List<PendingNotificationRequest> pendingNotifications =
    await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (final notification in pendingNotifications) {
      if (!exceptIds.contains(notification.id)) {
        log('Cancelling notification ID: ${notification.id}');
        await _flutterLocalNotificationsPlugin.cancel(notification.id);
      } else {
        log('Keeping notification ID: ${notification.id}');
      }
    }
  }

  static Future<String?> getNotificationPayload() async {
    final NotificationAppLaunchDetails? details =
    await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    return details?.notificationResponse?.payload;
  }

  static bool _isFileOpened = false; // Local flag to track if file was opened

  static void _handleNotificationClick(String? payload) async {
    if (payload == null) return;

    if (payload.startsWith("file://") ||
        payload.endsWith(".pdf") ||
        payload.endsWith(".xlsx") ||
        payload.endsWith(".jpg")) {
      if (!_isFileOpened) {
        final result = await OpenFile.open(payload);

        if (result.type != ResultType.done) {
          Fluttertoast.showToast(
            msg: "No application found to open this file",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );
          return;
        }
      }

      navigatorsKey.currentState
          ?.pushReplacementNamed('Dashboard', arguments: payload);
    } else if (payload == "0" || payload == "-1" || payload == "-2") {
      navigatorsKey.currentState
          ?.pushReplacementNamed('Dashboard', arguments: payload);
    } else {
      navigatorsKey.currentState
          ?.pushReplacementNamed('Dashboard', arguments: payload);
    }
  }

//simple Notification
  static Future showInstantNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    final bigTextStyleInformation = BigTextStyleInformation(
      body,
      contentTitle: title,
      summaryText: 'Budget Alert',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: bigTextStyleInformation,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.show(
      id ?? 0, // Fallback ID in case null
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }


  static Future<void> scheduleRepeatingNotification(
      String title,
      String body,
      DateTime scheduledDate,
      DateTimeComponents dateTimeComponent,
      int id,
      ) async {
    NotificationDetails androidNotificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel",
        'Recurring Notifications',
        channelDescription: 'Channel for repeating notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(scheduledDate, tz.local), androidNotificationDetails,
        matchDateTimeComponents:
        dateTimeComponent, // Triggers on the selected interval
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        payload: id.toString());
  }

  //schedule Notification
  static Future scheduleNotification(
      String title, String body, DateTime scheduledDate, int id) async {
    const NotificationDetails androidNotificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'),
        iOS: DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      androidNotificationDetails,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  static Future<void> scheduleDailyUntil({
    required String title,
    required String body,
    required DateTime start,
    required DateTime end,
    required int baseId,
  }) async {
    DateTime current = start;
    int count = 0;

    while (!current.isAfter(end)) {
      if (current.isAfter(DateTime.now())) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          baseId + count,
          title,
          body,
          tz.TZDateTime.from(current, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily_repeat_channel',
              'Daily Notifications',
              channelDescription:
              'Notifications that repeat daily until a date',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          matchDateTimeComponents: null,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
      } else {}

      current = current.add(const Duration(days: 1));
      count++;
    }
  }

  static Future<void> scheduleEveryIntervalUntil({
    required String title,
    required String body,
    required DateTime start,
    required DateTime end,
    required int baseId,
    required int intervalDays,
  }) async {
    DateTime current = start;
    int count = 0;

    while (!current.isAfter(end)) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        baseId + count,
        title,
        body,
        tz.TZDateTime.from(current, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'interval_channel',
            'Interval Notifications',
            channelDescription: 'Notifications at custom intervals',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents: null,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      current = current.add(Duration(days: intervalDays));
      count++;
    }
  }

  static Future<void> scheduleMonthlyUntil({
    required String title,
    required String body,
    required DateTime start,
    required DateTime end,
    required int baseId,
  }) async {
    DateTime current = start;
    int count = 0;

    while (!current.isAfter(end)) {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        baseId + count,
        title,
        body,
        tz.TZDateTime.from(current, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'monthly_channel',
            'Monthly Notifications',
            channelDescription: 'Notifications that repeat monthly',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents: null,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );

      current = DateTime(current.year, current.month + 1, current.day);
      count++;
    }
  }

  static Future<void> scheduleYearlyUntil({
    required String title,
    required String body,
    required DateTime start,
    required DateTime end,
    required int baseId,
  }) async {
    DateTime current = start;
    int count = 0;

    while (!current.isAfter(end)) {
      await scheduleNotification(title, body, current, baseId + count);
      current = DateTime(current.year + 1, current.month, current.day);
      count++;
    }
  }

  static Future<void> cancelAllWithPrefix(int baseId) async {
    for (int i = 0; i < 100; i++) {
      await _flutterLocalNotificationsPlugin.cancel(baseId + i);
    }
  }

  static Future<void> scheduleCancelOfRepeatingNotification(
      int baseNotificationId, DateTime endDateTime) async {
    final now = DateTime.now();
    final actualScheduleTime = endDateTime.add(const Duration(minutes: 1));

    if (actualScheduleTime.isBefore(now)) {
      return;
    }

    final tzEndDate = tz.TZDateTime.from(actualScheduleTime, tz.local);

    final int cancelId = baseNotificationId + 99999;

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      cancelId,
      'End of Repeats',
      'Recurring notification ended.',
      tzEndDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'cancel_override_channel',
          'Cancel Override',
          channelDescription: 'Cancels recurring notifications',
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.secret,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: null,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  //ow perodic Notification
  static Future showPerodicNotification({
    required String titile,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel 2', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        1, titile, body, RepeatInterval.everyMinute, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.alarmClock);
  }

  //stop notification
  static Future cancel(id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
