// lib/services/notification_service.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  // --- Your OneSignal Credentials ---
  static const String _oneSignalAppId = "0cd6bbc2-700d-487f-a459-50b4cc6b3652";
  static const String _oneSignalRestApiKey = "os_v2_app_btllxqtqbveh7jczkc2my2zwkkct23ngsbaebd4u63wwfthuocfomk3ckbyzq7uvq4evcmfvyetuw47b4ezvko2avqnnul3yoc76sca";

  /// Sends a notification to all subscribed users via OneSignal.
  static Future<void> sendGlobalNotification(String heading, String content) async {
    try {
      final response = await http.post(
        Uri.parse('https://onesignal.com/api/v1/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Basic $_oneSignalRestApiKey'
        },
        body: jsonEncode(<String, dynamic>{
          'app_id': _oneSignalAppId,
          'included_segments': ['Subscribed Users'],
          'headings': {'en': heading},
          'contents': {'en': content},
        }),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Notification sent successfully.");
        }
      } else {
        if (kDebugMode) {
          print("Failed to send notification: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while sending notification: $e");
      }
    }
  }
}