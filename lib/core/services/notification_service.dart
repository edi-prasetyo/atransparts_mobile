import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  const NotificationService();

  Future<NotificationSettings> getNotificationSettings() async {
    return await FirebaseMessaging.instance.getNotificationSettings();
  }

  Future<NotificationSettings> requestPermission() async {
    return await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<String?> getApnsToken() async {
    return await FirebaseMessaging.instance.getAPNSToken();
  }

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static bool isAuthorized(NotificationSettings settings) {
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}