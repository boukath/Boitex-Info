// lib/shared_widgets/section_list_item.dart
import 'package:flutter/material.dart';

// An abstract class to represent any item that can be shown in our generic list.
abstract class SectionListItem {
  String get id_;
  String get title; // e.g., Client Name
  String get subtitle; // e.g., Issue or Model Type
  DateTime get date;
  String get statusText;
  Color get statusColor;
  IconData? get priorityIcon; // An optional icon for priority/level
  Color? get priorityIconColor;
  VoidCallback get onTap; // The action to perform when the card is tapped
}