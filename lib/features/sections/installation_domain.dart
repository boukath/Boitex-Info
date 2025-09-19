// lib/features/sections/installation_domain.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

enum InstallationStatus {
  New,
  Assigned,
  InProgress,
  OnHold,
  Completed,
}

class Installation {
  final String? id;

  // Request Fields
  final String code;
  final String clientName;
  final String storeLocation;
  final DateTime date;
  final String phone;
  final String modelType;
  final String config;
  final String accessories;
  final String level;
  final String comment;

  // Professional Features
  final InstallationStatus status;
  final List<String>? assignedTechnicianIds;
  final List<String>? assignedTechnicianNames;
  final List<Map<String, dynamic>>? checklist;
  final List<Map<String, dynamic>>? installedAssets;
  final List<Map<String, dynamic>>? statusHistory;

  // Completion Fields (nullable)
  final String? completingTechnicianName;
  final String? managerName;
  final DateTime? completionDate;
  final Uint8List? managerSignaturePng;
  final Uint8List? clientSignaturePng;
  // --- 1. ADDED the new field ---
  final String? clientSatisfactionNote;

  Installation({
    this.id,
    required this.code,
    required this.clientName,
    required this.storeLocation,
    required this.date,
    required this.phone,
    required this.modelType,
    required this.config,
    required this.accessories,
    required this.level,
    this.comment = '',
    this.status = InstallationStatus.New,
    this.assignedTechnicianIds,
    this.assignedTechnicianNames,
    this.checklist,
    this.installedAssets,
    this.statusHistory,
    this.completingTechnicianName,
    this.managerName,
    this.completionDate,
    this.managerSignaturePng,
    this.clientSignaturePng,
    // --- 2. ADDED to constructor ---
    this.clientSatisfactionNote,
  });

  bool get isCompleted => status == InstallationStatus.Completed;

  Installation copyWith({
    String? id,
    String? code,
    String? clientName,
    String? storeLocation,
    DateTime? date,
    String? phone,
    String? modelType,
    String? config,
    String? accessories,
    String? level,
    String? comment,
    InstallationStatus? status,
    List<String>? assignedTechnicianIds,
    List<String>? assignedTechnicianNames,
    List<Map<String, dynamic>>? checklist,
    List<Map<String, dynamic>>? installedAssets,
    List<Map<String, dynamic>>? statusHistory,
    String? completingTechnicianName,
    String? managerName,
    DateTime? completionDate,
    Uint8List? managerSignaturePng,
    Uint8List? clientSignaturePng,
    // --- 3. ADDED to copyWith ---
    String? clientSatisfactionNote,
  }) {
    return Installation(
      id: id ?? this.id,
      code: code ?? this.code,
      clientName: clientName ?? this.clientName,
      storeLocation: storeLocation ?? this.storeLocation,
      date: date ?? this.date,
      phone: phone ?? this.phone,
      modelType: modelType ?? this.modelType,
      config: config ?? this.config,
      accessories: accessories ?? this.accessories,
      level: level ?? this.level,
      comment: comment ?? this.comment,
      status: status ?? this.status,
      assignedTechnicianIds: assignedTechnicianIds ?? this.assignedTechnicianIds,
      assignedTechnicianNames: assignedTechnicianNames ?? this.assignedTechnicianNames,
      checklist: checklist ?? this.checklist,
      installedAssets: installedAssets ?? this.installedAssets,
      statusHistory: statusHistory ?? this.statusHistory,
      completingTechnicianName: completingTechnicianName ?? this.completingTechnicianName,
      managerName: managerName ?? this.managerName,
      completionDate: completionDate ?? this.completionDate,
      managerSignaturePng: managerSignaturePng ?? this.managerSignaturePng,
      clientSignaturePng: clientSignaturePng ?? this.clientSignaturePng,
      clientSatisfactionNote: clientSatisfactionNote ?? this.clientSatisfactionNote,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'clientName': clientName,
      'storeLocation': storeLocation,
      'date': Timestamp.fromDate(date),
      'phone': phone,
      'modelType': modelType,
      'config': config,
      'accessories': accessories,
      'level': level,
      'comment': comment,
      'status': status.name,
      'assignedTechnicianIds': assignedTechnicianIds,
      'assignedTechnicianNames': assignedTechnicianNames,
      'checklist': checklist,
      'installedAssets': installedAssets,
      'statusHistory': statusHistory,
      'completingTechnicianName': completingTechnicianName,
      'managerName': managerName,
      'completionDate': completionDate != null ? Timestamp.fromDate(completionDate!) : null,
      'managerSignatureBase64': managerSignaturePng != null ? base64Encode(managerSignaturePng!) : null,
      'clientSignatureBase64': clientSignaturePng != null ? base64Encode(clientSignaturePng!) : null,
      // --- 4. ADDED to toJson ---
      'clientSatisfactionNote': clientSatisfactionNote,
    };
  }

  factory Installation.fromJson(Map<String, dynamic> json, String documentId) {
    return Installation(
      id: documentId,
      code: json['code'] as String,
      clientName: json['clientName'] as String,
      storeLocation: json['storeLocation'] as String,
      date: (json['date'] as Timestamp).toDate(),
      phone: json['phone'] as String,
      modelType: json['modelType'] as String,
      config: json['config'] as String,
      accessories: json['accessories'] as String,
      level: json['level'] as String,
      comment: json['comment'] as String? ?? '',
      status: InstallationStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => InstallationStatus.New,
      ),
      assignedTechnicianIds: (json['assignedTechnicianIds'] as List<dynamic>?)?.cast<String>(),
      assignedTechnicianNames: (json['assignedTechnicianNames'] as List<dynamic>?)?.cast<String>(),
      checklist: (json['checklist'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      installedAssets: (json['installedAssets'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      statusHistory: (json['statusHistory'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      completingTechnicianName: json['completingTechnicianName'] as String?,
      managerName: json['managerName'] as String?,
      completionDate: (json['completionDate'] as Timestamp?)?.toDate(),
      managerSignaturePng: json['managerSignatureBase64'] != null ? base64Decode(json['managerSignatureBase64']) : null,
      clientSignaturePng: json['clientSignatureBase64'] != null ? base64Decode(json['clientSignatureBase64']) : null,
      // --- 5. ADDED to fromJson ---
      clientSatisfactionNote: json['clientSatisfactionNote'] as String?,
    );
  }
}