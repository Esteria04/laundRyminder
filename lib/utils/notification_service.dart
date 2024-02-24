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

  Future<void> show5mNotification() async {
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

  Future<void> showEndedNotification(String type) async {
    const int notificationId = 1;

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
      '${type}ing Done',
      "Please pick up your laundry",
      notificationDetails,
    );
  }

  Future<void> showOtherMachineNotification(String type, int code) async {
    const int notificationId = 1;

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
      "Time to get ready for the laundry!",
      "You can use $type No.$code soon",
      notificationDetails,
    );
  }

  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
}
