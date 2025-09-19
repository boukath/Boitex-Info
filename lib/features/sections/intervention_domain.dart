// lib/features/sections/intervention_domain.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

enum InterventionStatus {
  New,
  Assigned,
  InProgress,
  OnHold,
  Resolved,
}

class Intervention {
  final String? id;
  final String code;
  final String clientName;
  final DateTime date;
  final String storeLocation;
  final String issue;
  final String level;
  final String comment;

  final InterventionStatus status;
  final List<String>? assignedTechnicianIds;
  final List<String>? assignedTechnicianNames;
  final List<String>? photoUrls;
  final String? clientSignatureBase64;
  final List<Map<String, dynamic>>? statusHistory;

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
    DateTime _parseDate(dynamic timestamp, {required DateTime fallback}) {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      }
      return fallback;
    }

    DateTime? _parseNullableDate(dynamic timestamp) {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      }
      return null;
    }

    return Intervention(
      id: documentId,
      code: json['code'] as String? ?? 'N/A',
      clientName: json['clientName'] as String? ?? 'N/A',
      date: _parseDate(json['date'], fallback: DateTime.now()),
      storeLocation: json['storeLocation'] as String? ?? '',
      issue: json['issue'] as String? ?? '',
      level: json['level'] as String? ?? 'Normal', // UPDATED
      comment: json['comment'] as String? ?? '',
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
      reportDate: _parseNullableDate(json['reportDate']),
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