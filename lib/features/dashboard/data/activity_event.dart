// lib/features/dashboard/data/activity_event.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // FIX: Add this import

class ActivityEvent {
  final String text;
  final Timestamp timestamp;
  final IconData icon;

  ActivityEvent({required this.text, required this.timestamp, required this.icon});

  factory ActivityEvent.fromJson(Map<String, dynamic> json) {
    return ActivityEvent(
      text: json['text'] as String,
      timestamp: json['timestamp'] as Timestamp,
      icon: _mapIcon(json['icon'] as String?),
    );
  }

  static IconData _mapIcon(String? iconName) {
    switch (iconName) {
      case 'assignment':
        return Icons.person_add_alt_1_outlined;
      case 'status_change':
        return Icons.sync_alt_outlined;
      case 'resolved':
        return Icons.task_alt_outlined;
      default:
        return Icons.notifications_none;
    }
  }
}