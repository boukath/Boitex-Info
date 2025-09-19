// lib/core/notification_service.dart

import 'dart:async';
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../features/sections/intervention_domain.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  StreamSubscription? _interventionsSubscription;

  // 1. Initialize the local notifications plugin
  Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Make sure you have this icon
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);
  }

  // 2. Show a local notification on the device
  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'boitex-info-channel',
      'New Assignments',
      channelDescription: 'Notifications for new job assignments',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);
    await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.toSigned(53), // Unique ID
        title,
        body,
        notificationDetails
    );
  }

  // 3. Listen for new assignments in real-time
  void listenForNewAssignments(BoitexUser user) {
    // Stop any previous listener to avoid duplicates
    _interventionsSubscription?.cancel();

    final query = FirebaseFirestore.instance
        .collection('interventions')
        .where('assignedTechnicianIds', arrayContains: user.uid)
        .where('status', isEqualTo: 'Assigned');

    _interventionsSubscription = query.snapshots().listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        // Only trigger for documents that were newly added to this query result
        if (docChange.type == DocumentChangeType.added) {
          final data = docChange.doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final intervention = Intervention.fromJson(data, docChange.doc.id);
            _showLocalNotification(
              'New Intervention Assigned!',
              'You have been assigned to ${intervention.code} for: ${intervention.clientName}.',
            );
          }
        }
      }
    });
    // NOTE: You would add similar listeners for Installations and SAV tickets here
  }

  // 4. Clean up the listener when it's no longer needed
  void dispose() {
    _interventionsSubscription?.cancel();
  }
}