import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification() async {
    const int notificationId = 0;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'laundryminder_channel',
      'laundryminder channel',
      channelDescription:
          'This channel is used for laundryminder notifications',
      importance: Importance.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      '5 minutes left',
      "Your laundry is almost done!",
      notificationDetails,
    );
  }

  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
}
