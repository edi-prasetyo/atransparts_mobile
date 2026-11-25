import 'package:flutter/material.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/services/secure_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/error_display_widget.dart';
import 'routes/app_router.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // print('Background Message: ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _showForegroundNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'kvlari_channel',
        'Kvlari Notifications',
        channelDescription: 'Notification channel for Kvlari Notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    id: message.notification.hashCode,
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    notificationDetails: platformChannelSpecifics,
    payload: message.messageId,
  );
}

Future<void> _setupFirebaseMessaging() async {
  try {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // print('Firebase Messaging initialized');

    await messaging.getToken();
    // print('FCM Token: $token');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // print('FCM Token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print('Foreground Message: ${message.messageId}');
      // print('Foreground Message Title: ${message.notification?.title}');
      // print('Foreground Message Body: ${message.notification?.body}');

      if (message.notification != null) {
        // print('Message also contained a notification: ${message.notification}');
        _showForegroundNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print('Notification opened app: ${message.messageId}');
      // print('Data: ${message.data}');
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  } catch (e) {
    // print('Firebase Messaging setup failed: $e');
  }
  // print('========== FIREBASE MESSAGING SETUP DONE ==========');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // print('========== MAIN START ==========');

  try {
    // print('[1] Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // print('[1] Firebase initialized');

    // print('[2] Registering background message handler...');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // print('[2] Background handler registered');

    // print('[3] Setting up Firebase Messaging...');
    await _setupFirebaseMessaging();
    // print('[3] Firebase Messaging setup done');

    // print('[4] Date formatting initialized');
  } catch (e) {
    // print('========== APP INIT ERROR ==========');
    // print('Error: $e');
  }

  // print('[5] Running app...');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('========== MyApp BUILD START ==========');
    final router = ref.watch(appRouterProvider);
    final isDarkModeAsync = ref.watch(darkModeProvider);
    final isDarkMode = isDarkModeAsync.value ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _printStoredTokens(ref);
      ref.read(authProvider.notifier).initialize();
    });

    final app = MaterialApp.router(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      routerConfig: router,

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return GlobalTransientErrorListener(child: child);
      },
    );

    return app;
  }

  Future<void> _printStoredTokens(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    await storage.getToken();
    await storage.getRefreshToken();
    await storage.getExpiresIn();
  }
}
