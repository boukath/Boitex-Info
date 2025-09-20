// lib/features/sections/intervention_domain.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../shared_widgets/section_list_item.dart';

enum InterventionStatus {
  New,
  Assigned,
  InProgress,
  OnHold,
  Resolved,
}

class Intervention implements SectionListItem {
  final String? id;
  final String code;
  final String clientName;
  final DateTime date;
  final String storeLocation;
  final String issue;
  final String level;
  final String comment;
  final bool? notificationSent;
  final bool? resolvedNotificationSent;

  final InterventionStatus status;
  final List<String>? assignedTechnicianIds;
  final List<String>? assignedTechnicianNames;
  final List<String>? photoUrls;
  final String? clientSignatureBase64;
  final List<Map<String, dynamic>>? statusHistory;

  // Report Fields
  final String? technicianName;
  final String? managerName;
  final DateTime? reportDate;
  final String? arrivalTime;
  final String? departureTime;
  final String? modelType;
  final String? diagnostic;
  final String? workDone;
  final String? partsUsed;
  final String? managerSignatureBase64;

  Intervention({
    this.id,
    required this.code,
    required this.clientName,
    required this.date,
    required this.storeLocation,
    required this.issue,
    required this.level,
    this.comment = '',
    this.notificationSent,
    this.resolvedNotificationSent,
    this.status = InterventionStatus.New,
    this.assignedTechnicianIds,
    this.assignedTechnicianNames,
    this.photoUrls,
    this.clientSignatureBase64,
    this.statusHistory,
    this.technicianName,
    this.managerName,
    this.reportDate,
    this.arrivalTime,
    this.departureTime,
    this.modelType,
    this.diagnostic,
    this.workDone,
    this.partsUsed,
    this.managerSignatureBase64,
  });

  // --- Mappings for SectionListItem ---
  @override
  String get id_ => this.id!;
  @override
  String get title => this.clientName;
  @override
  String get subtitle => this.issue;
  // date is already present
  @override
  String get statusText => this.status.name;
  @override
  Color get statusColor {
    return switch (status) {
      InterventionStatus.New => Colors.grey.shade500,
      InterventionStatus.Assigned => Colors.purple.shade400,
      InterventionStatus.InProgress => Colors.blue.shade400,
      InterventionStatus.OnHold => Colors.amber.shade500,
      InterventionStatus.Resolved => Colors.green.shade500,
    };
  }
  @override
  IconData? get priorityIcon => Icons.flag_rounded;
  @override
  Color? get priorityIconColor {
    return switch (level) {
      'High Urgent' => Colors.red.shade400,
      'Medium' => Colors.amber.shade700,
      _ => Colors.green.shade400,
    };
  }
  @override
  late final VoidCallback onTap;

  // --- Other getters and methods ---
  bool get hasReport => status == InterventionStatus.Resolved;
  Uint8List? get managerSignatureBytes => managerSignatureBase64 != null ? base64Decode(managerSignatureBase64!) : null;
  Uint8List? get clientSignatureBytes => clientSignatureBase64 != null ? base64Decode(clientSignatureBase64!) : null;

  Intervention copyWith({
    String? id,
    String? code,
    String? clientName,
    DateTime? date,
    String? storeLocation,
    String? issue,
    String? level,
    String? comment,
    bool? notificationSent,
    bool? resolvedNotificationSent,
    InterventionStatus? status,
    List<String>? assignedTechnicianIds,
    List<String>? assignedTechnicianNames,
    List<String>? photoUrls,
    String? clientSignatureBase64,
    List<Map<String, dynamic>>? statusHistory,
    String? technicianName,
    String? managerName,
    DateTime? reportDate,
    String? arrivalTime,
    String? departureTime,
    String? modelType,
    String? diagnostic,
    String? workDone,
    String? partsUsed,
    String? managerSignatureBase64,
  }) {
    return Intervention(
      id: id ?? this.id,
      code: code ?? this.code,
      clientName: clientName ?? this.clientName,
      date: date ?? this.date,
      storeLocation: storeLocation ?? this.storeLocation,
      issue: issue ?? this.issue,
      level: level ?? this.level,
      comment: comment ?? this.comment,
      notificationSent: notificationSent ?? this.notificationSent,
      resolvedNotificationSent: resolvedNotificationSent ?? this.resolvedNotificationSent,
      status: status ?? this.status,
      assignedTechnicianIds: assignedTechnicianIds ?? this.assignedTechnicianIds,
      assignedTechnicianNames: assignedTechnicianNames ?? this.assignedTechnicianNames,
      photoUrls: photoUrls ?? this.photoUrls,
      clientSignatureBase64: clientSignatureBase64 ?? this.clientSignatureBase64,
      statusHistory: statusHistory ?? this.statusHistory,
      technicianName: technicianName ?? this.technicianName,
      managerName: managerName ?? this.managerName,
      reportDate: reportDate ?? this.reportDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      modelType: modelType ?? this.modelType,
      diagnostic: diagnostic ?? this.diagnostic,
      workDone: workDone ?? this.workDone,
      partsUsed: partsUsed ?? this.partsUsed,
      managerSignatureBase64: managerSignatureBase64 ?? this.managerSignatureBase64,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'clientName': clientName,
      'date': Timestamp.fromDate(date),
      'storeLocation': storeLocation,
      'issue': issue,
      'level': level,
      'comment': comment,
      'notificationSent': notificationSent,
      'resolvedNotificationSent': resolvedNotificationSent,
      'status': status.name,
      'assignedTechnicianIds': assignedTechnicianIds,
      'assignedTechnicianNames': assignedTechnicianNames,
      'photoUrls': photoUrls,
      'clientSignatureBase64': clientSignatureBase64,
      'statusHistory': statusHistory,
      'technicianName': technicianName,
      'managerName': managerName,
      'reportDate': reportDate != null ? Timestamp.fromDate(reportDate!) : null,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'modelType': modelType,
      'diagnostic': diagnostic,
      'workDone': workDone,
      'partsUsed': partsUsed,
      'managerSignatureBase64': managerSignatureBase64,
    };
  }

  factory Intervention.fromJson(Map<String, dynamic> json, String documentId) {
    return Intervention(
      id: documentId,
      code: json['code'] as String,
      clientName: json['clientName'] as String,
      date: (json['date'] as Timestamp).toDate(),
      storeLocation: json['storeLocation'] as String? ?? '',
      issue: json['issue'] as String? ?? '',
      level: json['level'] as String? ?? 'Normal',
      comment: json['comment'] as String? ?? '',
      notificationSent: json['notificationSent'] as bool?,
      resolvedNotificationSent: json['resolvedNotificationSent'] as bool?,
      status: InterventionStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => InterventionStatus.New,
      ),
      assignedTechnicianIds: (json['assignedTechnicianIds'] as List<dynamic>?)?.cast<String>(),
      assignedTechnicianNames: (json['assignedTechnicianNames'] as List<dynamic>?)?.cast<String>(),
      photoUrls: (json['photoUrls'] as List<dynamic>?)?.cast<String>(),
      clientSignatureBase64: json['clientSignatureBase64'] as String?,
      statusHistory: (json['statusHistory'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      technicianName: json['technicianName'] as String?,
      managerName: json['managerName'] as String?,
      reportDate: (json['reportDate'] as Timestamp?)?.toDate(),
      arrivalTime: json['arrivalTime'] as String?,
      departureTime: json['departureTime'] as String?,
      modelType: json['modelType'] as String?,
      diagnostic: json['diagnostic'] as String?,
      workDone: json['workDone'] as String?,
      partsUsed: json['partsUsed'] as String?,
      managerSignatureBase64: json['managerSignatureBase64'] as String?,
    );
  }
}