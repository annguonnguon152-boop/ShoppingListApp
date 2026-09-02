import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shoppinglist_app/utils/app_navigator.dart';
import 'package:shoppinglist_app/views/widgets/onsale_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // separate ID ranges
  static const int onSaleBaseId = 1000;
  static const int shoppingReminderBaseId = 10000;

  // INIT
  static Future<void> init() async {
    // prevent initialize more than once
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();

    tz.setLocalLocation(
      tz.getLocation('Asia/Phnom_Penh'),
    );

    const androidSetting =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSetting =
        InitializationSettings(
      android: androidSetting,
    );

    await notifications.initialize(
      settings: initSetting,

      onDidReceiveNotificationResponse:
          (NotificationResponse response) {
        handleNotificationTap(
          response.payload,
        );
      },
    );

    _initialized = true;
  }

  // REQUEST PERMISSION
  static Future<void>
  requestNotificationPermission() async {
    final androidNotification =
        notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await androidNotification
        ?.requestNotificationsPermission();
  }

  // HANDLE TAP
  static void handleNotificationTap(
    String? payload,
  ) {
    if (payload == null) {
      return;
    }

    print('Notification payload: $payload');

    // Don't navigate immediately during
    // widget-tree/lifecycle transition.
    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        final navigator =
            navigatorKey.currentState;

        if (navigator == null ||
            !navigator.mounted) {
          return;
        }

        // ON SALE
        if (payload == 'on_sale') {
          navigator.push(
            MaterialPageRoute(
              builder: (context) =>
                  const OnsalePage(),
            ),
          );

          return;
        }

        // SHOPPING REMINDER
        if (payload.startsWith(
          'shopping_reminder:',
        )) {
          final id = int.tryParse(
            payload.split(':').last,
          );

          print(
            'Shopping reminder list id = $id',
          );

          // later:
          // navigator.push(...)
        }
      },
    );
  }

  // ON SALE
  static Future<void>
  showOnSaleNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetail =
        AndroidNotificationDetails(
      'on_sale_notification',
      'On Sale',
      channelDescription:
          'Notifications for discounted items',
      importance: Importance.high,
      priority: Priority.high,
    );

    const detail =
        NotificationDetails(
      android: androidDetail,
    );

    // Example:
    // id 1 becomes 1001
    final notificationId =
        onSaleBaseId + id;

    await notifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: detail,
      payload: 'on_sale',
    );
  }

  // SHOPPING REMINDER
  static Future<void>
  scheduleShoppingReminder({
    required int id,
    required String listName,
    required DateTime dateTime,
  }) async {
    if (!dateTime.isAfter(
      DateTime.now(),
    )) {
      throw Exception(
        'Reminder time must be in the future',
      );
    }

    const androidDetail =
        AndroidNotificationDetails(
      'shopping_reminder',
      'Shopping Reminder',
      channelDescription:
          'Reminders for saved shopping lists',
      importance: Importance.high,
      priority: Priority.high,
    );

    const detail =
        NotificationDetails(
      android: androidDetail,
    );

    final scheduledDate =
        tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    // Example:
    // list id 1 becomes notification 10001
    final notificationId =
        shoppingReminderBaseId + id;

    print(
      'Schedule reminder ID: $notificationId',
    );

    print(
      'Schedule reminder time: $scheduledDate',
    );

    await notifications.zonedSchedule(
      id: notificationId,
      title: 'Shopping Reminder',
      body:
          'Don\'t forget your "$listName" shopping list.',
      scheduledDate: scheduledDate,
      notificationDetails: detail,
      androidScheduleMode:
          AndroidScheduleMode
              .inexactAllowWhileIdle,
      payload:
          'shopping_reminder:$id',
    );

    print(
      'Reminder scheduled successfully',
    );
  }

  // CANCEL SHOPPING REMINDER
  static Future<void>
  cancelShoppingReminder(
    int listId,
  ) async {
    final notificationId =
        shoppingReminderBaseId +
        listId;

    await notifications.cancel(
      id: notificationId,
    );
  }

  // CANCEL ON SALE
  static Future<void>
  cancelOnSaleNotification(
    int id,
  ) async {
    await notifications.cancel(
      id: onSaleBaseId + id,
    );
  }

  // CANCEL RAW ID
  static Future<void>
  cancelNotification(int id) async {
    await notifications.cancel(
      id: id,
    );
  }

  static Future<void>
  cancelAllNotifications() async {
    await notifications.cancelAll();
  }
}