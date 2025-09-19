// lib/features/surveys/site_survey.dart
import 'package:cloud_firestore/cloud_firestore.dart';

// Enum for the entrance type
enum EntranceType { noDoor, glassDoor, autoGlassDoor }

class SiteSurvey {
  final String? id;
  final String clientName;
  final String storeLocation;
  final DateTime surveyDate;
  final String surveyedByName;
  final String clientNeeds;
  final List<Map<String, dynamic>> entrances;
  final bool isPowerAvailable;
  final bool hasUndergroundTube;
  final bool canCutFloor;

  SiteSurvey({
    this.id,
    required this.clientName,
    required this.storeLocation,
    required this.surveyDate,
    required this.surveyedByName,
    required this.clientNeeds,
    required this.entrances,
    required this.isPowerAvailable,
    required this.hasUndergroundTube,
    required this.canCutFloor,
  });

  Map<String, dynamic> toJson() => {
    'clientName': clientName,
    'storeLocation': storeLocation,
    'surveyDate': Timestamp.fromDate(surveyDate),
    'surveyedByName': surveyedByName,
    'clientNeeds': clientNeeds,
    'entrances': entrances,
    'isPowerAvailable': isPowerAvailable,
    'hasUndergroundTube': hasUndergroundTube,
    'canCutFloor': canCutFloor,
  };

// Note: We'll create a fromJson factory later if we build a survey viewing page.
}