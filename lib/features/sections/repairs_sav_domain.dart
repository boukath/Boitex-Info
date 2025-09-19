// lib/features/sections/repairs_sav_domain.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SavStatus {
  New,
  Assigned,
  Diagnosing,
  AwaitingParts,
  RepairInProgress,
  Repaired,
  ReturnedToClient,
}

class SavTicket {
  final String? id;
  final String code;
  final DateTime date;
  final String client;

  final SavStatus status;
  final List<String>? assignedTechnicianIds;
  final List<String>? assignedTechnicianNames;

  final List<Map<String, dynamic>>? repairedAssets;
  final String diagnostic;
  final String partsRequired;
  final String repairPerformed;
  final List<Map<String, dynamic>>? resolutionChecklist;
  final DateTime? arrivalDate;
  final DateTime? returnDate;
  final Uint8List? clientSignaturePng;
  final Uint8List? intakeSignaturePng;
  final List<Map<String, dynamic>>? statusHistory;
  final String comment;

  SavTicket({
    this.id,
    required this.code,
    required this.date,
    required this.client,
    this.status = SavStatus.New,
    this.assignedTechnicianIds,
    this.assignedTechnicianNames,
    this.repairedAssets,
    this.diagnostic = '',
    this.partsRequired = '',
    this.repairPerformed = '',
    this.resolutionChecklist,
    this.arrivalDate,
    this.returnDate,
    this.clientSignaturePng,
    this.intakeSignaturePng,
    this.statusHistory,
    this.comment = '',
  });

  SavTicket copyWith({
    String? id,
    String? code,
    DateTime? date,
    String? client,
    SavStatus? status,
    List<String>? assignedTechnicianIds,
    List<String>? assignedTechnicianNames,
    List<Map<String, dynamic>>? repairedAssets,
    String? diagnostic,
    String? partsRequired,
    String? repairPerformed,
    List<Map<String, dynamic>>? resolutionChecklist,
    DateTime? arrivalDate,
    DateTime? returnDate,
    Uint8List? clientSignaturePng,
    Uint8List? intakeSignaturePng,
    List<Map<String, dynamic>>? statusHistory,
    String? comment,
  }) {
    return SavTicket(
      id: id ?? this.id,
      code: code ?? this.code,
      date: date ?? this.date,
      client: client ?? this.client,
      status: status ?? this.status,
      assignedTechnicianIds: assignedTechnicianIds ?? this.assignedTechnicianIds,
      assignedTechnicianNames: assignedTechnicianNames ?? this.assignedTechnicianNames,
      repairedAssets: repairedAssets ?? this.repairedAssets,
      diagnostic: diagnostic ?? this.diagnostic,
      partsRequired: partsRequired ?? this.partsRequired,
      repairPerformed: repairPerformed ?? this.repairPerformed,
      resolutionChecklist: resolutionChecklist ?? this.resolutionChecklist,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      returnDate: returnDate ?? this.returnDate,
      clientSignaturePng: clientSignaturePng ?? this.clientSignaturePng,
      intakeSignaturePng: intakeSignaturePng ?? this.intakeSignaturePng,
      statusHistory: statusHistory ?? this.statusHistory,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'date': Timestamp.fromDate(date),
      'client': client,
      'status': status.name,
      'assignedTechnicianIds': assignedTechnicianIds,
      'assignedTechnicianNames': assignedTechnicianNames,
      'repairedAssets': repairedAssets,
      'diagnostic': diagnostic,
      'partsRequired': partsRequired,
      'repairPerformed': repairPerformed,
      'resolutionChecklist': resolutionChecklist,
      'arrivalDate': arrivalDate != null ? Timestamp.fromDate(arrivalDate!) : null,
      'returnDate': returnDate != null ? Timestamp.fromDate(returnDate!) : null,
      'clientSignatureBase64': clientSignaturePng != null ? base64Encode(clientSignaturePng!) : null,
      'intakeSignatureBase64': intakeSignaturePng != null ? base64Encode(intakeSignaturePng!) : null,
      'statusHistory': statusHistory,
      'comment': comment,
    };
  }

  factory SavTicket.fromJson(Map<String, dynamic> json, String documentId) {
    return SavTicket(
      id: documentId,
      code: json['code'] as String,
      date: (json['date'] as Timestamp).toDate(),
      client: json['client'] as String,
      status: SavStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => SavStatus.New,
      ),
      assignedTechnicianIds: (json['assignedTechnicianIds'] as List<dynamic>?)?.cast<String>(),
      assignedTechnicianNames: (json['assignedTechnicianNames'] as List<dynamic>?)?.cast<String>(),
      repairedAssets: (json['repairedAssets'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      diagnostic: json['diagnostic'] as String? ?? '',
      partsRequired: json['partsRequired'] as String? ?? '',
      repairPerformed: json['repairPerformed'] as String? ?? '',
      resolutionChecklist: (json['resolutionChecklist'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      arrivalDate: (json['arrivalDate'] as Timestamp?)?.toDate(),
      returnDate: (json['returnDate'] as Timestamp?)?.toDate(),
      clientSignaturePng: json['clientSignatureBase64'] != null ? base64Decode(json['clientSignatureBase64']) : null,
      intakeSignaturePng: json['intakeSignatureBase64'] != null ? base64Decode(json['intakeSignatureBase64']) : null,
      statusHistory: (json['statusHistory'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
      comment: json['comment'] as String? ?? '',
    );
  }
}