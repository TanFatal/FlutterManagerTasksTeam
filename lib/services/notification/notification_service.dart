// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// abstract class NotificationService {
//   Future<void> initialize();

//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   });

//   Future<void> cancelNotification(int id);

//   Future<void> cancelAllNotifications();
// }

// class LocalNotificationService implements NotificationService {
//   final FlutterLocalNotificationsPlugin _notifications;
//   final void Function(String?)? onNotificationTap;

//   LocalNotificationService({
//     FlutterLocalNotificationsPlugin? notifications,
//     this.onNotificationTap,
//   }) : _notifications = notifications ?? FlutterLocalNotificationsPlugin();

//   @override
//   Future<void> initialize() async {
//     const androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iOSSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const settings = InitializationSettings(
//       android: androidSettings,
//       iOS: iOSSettings,
//     );

//     await _notifications.initialize(
//       settings,
//       onDidReceiveNotificationResponse: (details) {
//         onNotificationTap?.call(details.payload);
//       },
//     );
//   }

//   @override
//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'vinachem_shop_channel',
//       'Vinachem Shop Notifications',
//       channelDescription: 'Notifications from Vinachem Shop',
//       importance: Importance.high,
//       priority: Priority.high,
//       color: null,
//     );

//     const iOSDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iOSDetails,
//     );

//     await _notifications.show(
//       id,
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   @override
//   Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }

//   @override
//   Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }
// }
