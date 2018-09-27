import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final pushNotifications = _PushNotifications._internal();

class _PushNotifications {
  bool _isInitialized = false;

  FlutterLocalNotificationsPlugin _notificationsPlugin;
  NotificationDetails _details;

  String _channelId = "ParkingSessions";
  String _channelName = "Parking sessions";
  String _channelDescription =
      "Alerts you when a parking session is auto renewed";

  _PushNotifications._internal();

  Future<bool> initialize() async {
    if (_isInitialized) {
      return true;
    }

    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings("ic_notification");

    IOSInitializationSettings iosSettings = IOSInitializationSettings();

    InitializationSettings settings =
        InitializationSettings(androidSettings, iosSettings);

    _isInitialized = await _notificationsPlugin.initialize(settings);

    if (!_isInitialized) {
      return false;
    }

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      _channelDescription,
    );

    IOSNotificationDetails iosDetails = IOSNotificationDetails();

    _details = NotificationDetails(androidDetails, iosDetails);

    return true;
  }

  Future<bool> show(String title, String body) async {
    assert(_isInitialized);

    return await _notificationsPlugin
        .show(
          Random().nextInt(100),
          title,
          body,
          _details,
        )
        .then((_) => true)
        .catchError(() => false);
  }

  Future<bool> cancelAll() async {
    return await _notificationsPlugin
        .cancelAll()
        .then((_) => true)
        .catchError(() => false);
  }
}
