// ignore_for_file: unused_local_variable, empty_catches

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

dynamic token;

class NotificationService {
 
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

 
  final String _channelId = "sheep";

  Future<void> init() async {
    await _initLocalNotifications();
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(alert: true, badge: true, sound: true);

 
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    await messaging.setAutoInitEnabled(true);

    try {
      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 2));

        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();

        if (apnsToken == null) {
          return;
        }

        token = apnsToken;

        String? fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          token = fcmToken;
        }
      } else {
   
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          token = fcmToken;
          print("=============> token = ${token}");
          await FirebaseMessaging.instance.subscribeToTopic("sheep");
        }
      }

      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        token = newToken;
      });

      _listenFCM();
    } catch (e) {}
  }

  Future<void> _initLocalNotifications() async {
    var androidSettings = const AndroidInitializationSettings(
      '@drawable/logo_app',
    );
    var iosSettings = const DarwinInitializationSettings();
    var initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationSelected,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  int parseMessageId(String? id) {
    if (id == null || id.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

    final numeric = id.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeric.isEmpty) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }

    String lastDigits =
        numeric.length > 6 ? numeric.substring(numeric.length - 6) : numeric;

    return int.parse(lastDigits);
  }

  void _listenFCM() {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FCM Message Received: ${jsonEncode(message.data)}");

      if (message.notification != null) {
        _showNotification(
          messageId: parseMessageId(message.messageId),
          title: message.notification!.title,
          body: message.notification!.body,
          payload: jsonEncode(message.data),
        );
      }
      if (message.data.isNotEmpty) {
        _handleSilent(message.data);
      }
    });

    // Background / app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("FCM Opened Message: ${jsonEncode(message.data)}");
      
      if (  message.notification != null) {
        _showNotification(
          messageId: parseMessageId(message.messageId),
          title: message.notification!.title,
          body: message.notification!.body,
          payload: jsonEncode(message.data),
        );
      }
      _onNotificationSelected(
        NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: jsonEncode(message.data),
        ),
      );
    });
  }

  Future<void> _showNotification({
    required int messageId,
    String? title,
    String? body,
    required String payload,
  }) async {
    var androidDetails = AndroidNotificationDetails(
      _channelId,
      "Sheep Channel",
      channelDescription: "Default channel for notifications",
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/logo_app',
      largeIcon: DrawableResourceAndroidBitmap('@drawable/logo_app'),
    );

    var iosDetails = const DarwinNotificationDetails(presentSound: true);

    var details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      messageId,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _onNotificationSelected(NotificationResponse response) {
    if (response.payload == null) return;

    Map<String, dynamic> data = jsonDecode(response.payload!);

    // Example: handle routing by notification type
    String type = data['notification_type_id'].toString();
    log("Notification Type: $type");

    switch (type) {
      case "1":
        // Navigate to Auction Win Page

        break;
      case "30":
        // Silent / custom handling
        break;
      default:
        // Default action
        break;
    }
  }

  void _handleSilent(Map<String, dynamic> data) {
    String productId = data['product_id'].toString();
    String userId = data['user_id'].toString();
    switch (data['notification_type_id'].toString()) {
      case "30":
        
        break;
    }
    log("Silent Notification: ${jsonEncode(data)}");
  }

  // Optional: background handler
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print("Background message received: ${message.messageId}");
  }
}
