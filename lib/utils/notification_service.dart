import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessageBackgroundHandle(RemoteMessage message) async {}

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initInfo() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    var request = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (request.authorizationStatus == AuthorizationStatus.authorized || request.authorizationStatus == AuthorizationStatus.provisional) {
      AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
      var iosInitializationSettings = const DarwinInitializationSettings();
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: iosInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) {});

      const AndroidNotificationChannel orderChannel = AndroidNotificationChannel(
        'orders_channel',
        'Orders',
        description: 'Channel for new order notifications',
        importance: Importance.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('order_sound'),
      );

      const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
        'default_channel',
        'General',
        description: 'General notifications',
        importance: Importance.high,
        playSound: true,
      );

      final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.createNotificationChannel(orderChannel);
      await androidPlugin?.createNotificationChannel(defaultChannel);

      // Background handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessageBackgroundHandle);
      setupInteractedMessage();
    }

    await FirebaseMessaging.instance.subscribeToTopic("go4food-driver");

  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      FirebaseMessaging.onBackgroundMessage((message) => firebaseMessageBackgroundHandle(message));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        display(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.notification != null) {
        if (message.data['type'] == "chat") {
        } else if (message.data['type'] == "order") {}
      }
    });
  }

  static Future<String> getToken() async {
    try {
      // Ensure APNs token is available (for iOS)
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

      if (apnsToken == null) {
        print('⚠️ APNs token not yet available. Retrying later...');
        // You could retry later or just return empty string
        return '';
      }

      // Now safely request the FCM token
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null && token.isNotEmpty) {
        print('✅ FCM Token: $token');
        return token;
      } else {
        print('⚠️ FCM token not generated yet');
        return '';
      }

    } on FirebaseException catch (e) {
      print('🔥 FirebaseException in getToken(): ${e.code} - ${e.message}');
      return '';
    } catch (e, st) {
      print('❌ Unknown error in getToken(): $e');
      print(st);
      return '';
    }
  }

  void display(RemoteMessage message) async {
    try {
      bool isBooking = message.data['isNewOrder'] == 'true';
      AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        isBooking ? 'orders_channel' : 'default_channel',
        isBooking ? 'Orders' : 'General',
        channelDescription: 'Order Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: isBooking
            ? const RawResourceAndroidNotificationSound('order_sound')
            : null,
      );

      DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentSound: true,
        sound: isBooking ? 'order_sound.wav' : null,
      );

      NotificationDetails details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        details,
        payload: jsonEncode(message.data),
      );
    } on Exception {
      if (kDebugMode) {}
    }
  }
}
