// lib/core/services/notification_service.dart
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static Future<void> initOneSignal() async {
    // Set your OneSignal App ID
    OneSignal.shared.setAppId("0cd6bbc2-700d-487f-a459-50b4cc6b3652");

    // Optional: Set up a handler for when a notification is opened
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("Notification Opened: ${result.notification.body}");
      // Here you can add logic to navigate to a specific page
    });

    // Optional: Prompt for permission on iOS
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }
}