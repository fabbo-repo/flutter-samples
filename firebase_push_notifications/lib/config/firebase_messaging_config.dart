import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingConfig {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    debugPrint("[FIREBASE] Requesting permissions");
    // You may set the permission requests to "provisional" which allows the user to choose what type
    // of notifications they would like to receive once the user receives a notification.
    firebaseMessaging.requestPermission();

    // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
    }

    final token = await firebaseMessaging.getToken();
    debugPrint("[FIREBASE] FCM Token: $token");

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('[FIREBASE] A new onMessageOpenedApp event was published!');
      // Go to notifications view inside app
      /*Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, true),
      );*/
    });
  await firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  }

  static void showFlutterNotification(RemoteMessage message) {
    final data = message.data;
    debugPrint("[FIREBASE] Message: $data");
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('[FIREBASE] Handling a background message ${message.messageId}');
    showFlutterNotification(message);
  }
}
