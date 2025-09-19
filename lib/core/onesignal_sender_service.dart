// lib/core/onesignal_sender_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class OneSignalSenderService {
  // IMPORTANT: Replace these with your actual App ID and REST API Key from the OneSignal dashboard
  static const String _appId = "a31ef90f-698d-4a1b-ad8f-2911e3a97bdd";
  static const String _restApiKey = "os_v2_app_umppsd3jrvfbxlmpfei6hkl33wbtqwkxw77e37ukwza2iqkpjckjkb4ll2vdz3d23rmgu3qlqaly5thveyvjajfmnu5va2pezun2hna";

  Future<void> sendNotification({
    required List<String> userIds, // The Firebase UIDs of the users to notify
    required String title,
    required String body,
  }) async {

    // Security Warning: Storing your REST API Key directly in the app is convenient for
    // development but is not recommended for a production app, as it can be extracted.
    // For a production app, you would typically use a secure backend like Cloud Functions.

    if (userIds.isEmpty) return;

    final url = Uri.parse('https://onesignal.com/api/v1/notifications');

    final bodyData = {
      'app_id': _appId,
      // This tells OneSignal to send to specific users we tagged with their Firebase UID
      'include_external_user_ids': userIds,
      // The content of the notification
      'headings': {'en': title},
      'contents': {'en': body},
      // This helps group notifications on Android
      'android_channel_id': 'f8c2b3a8-9b48-4a6c-9a2c-f6c1b3f2e1a3', // Use your own channel ID from OneSignal settings
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $_restApiKey',
        },
        body: json.encode(bodyData),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully.");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}