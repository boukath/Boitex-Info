// lib/features/sections/livraison_domain.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum DeliveryStatus { pending, inTransit, delivered, cancelled }

String statusToString(DeliveryStatus status) {
  return status.name[0].toUpperCase() + status.name.substring(1);
}

IconData statusToIcon(DeliveryStatus status) {
  return switch (status) {
    DeliveryStatus.pending => Icons.pending_actions_outlined,
    DeliveryStatus.inTransit => Icons.local_shipping_outlined,
    DeliveryStatus.delivered => Icons.task_alt_outlined,
    DeliveryStatus.cancelled => Icons.cancel_outlined,
  };
}

class DeliveryLine {
  final String article;
  final int qty;
  final double? price;

  DeliveryLine({required this.article, required this.qty, this.price});

  Map<String, dynamic> toJson() => {'article': article, 'qty': qty, 'price': price};
  factory DeliveryLine.fromJson(Map<String, dynamic> json) => DeliveryLine(
    article: json['article'] as String,
    qty: json['qty'] as int,
    price: (json['price'] as num?)?.toDouble(),
  );
}

class DeliveryNote {
  final String? id;
  final String code;
  final String client;
  final String phone;
  final String location;
  final List<DeliveryLine> lines;
  final DeliveryStatus status;
  final String createdById;
  final String createdByName;
  final String? assignedDriverId;
  final String? assignedDriverName;
  final Timestamp createdAt;
  final Timestamp? inTransitAt;
  final Timestamp? deliveredAt;
  final List<Map<String, dynamic>>? statusHistory;
  final String? clientSignatureBase64;
  final String? photoBase64;

  DeliveryNote({
    this.id,
    required this.code,
    required this.client,
    required this.phone,
    required this.location,
    required this.lines,
    this.status = DeliveryStatus.pending,
    required this.createdById,
    required this.createdByName,
    this.assignedDriverId,
    this.assignedDriverName,
    required this.createdAt,
    this.inTransitAt,
    this.deliveredAt,
    this.statusHistory,
    this.clientSignatureBase64,
    this.photoBase64,
  });

  Uint8List? get clientSignaturePng => clientSignatureBase64 != null ? base64Decode(clientSignatureBase64!) : null;
  Uint8List? get photoPng => photoBase64 != null ? base64Decode(photoBase64!) : null;
  bool get isCompleted => status == DeliveryStatus.delivered;

  Map<String, dynamic> toJson() => {
    'code': code,
    'client': client,
    'phone': phone,
    'location': location,
    'lines': lines.map((line) => line.toJson()).toList(),
    'status': status.name,
    'createdById': createdById,
    'createdByName': createdByName,
    'assignedDriverId': assignedDriverId,
    'assignedDriverName': assignedDriverName,
    'createdAt': createdAt,
    'inTransitAt': inTransitAt,
    'deliveredAt': deliveredAt,
    'statusHistory': statusHistory,
    'clientSignatureBase64': clientSignatureBase64,
    'photoBase64': photoBase64,
  };

  factory DeliveryNote.fromJson(Map<String, dynamic> json, String id) =>
      DeliveryNote(
        id: id,
        code: json['code'] as String,
        client: json['client'] as String,
        phone: json['phone'] as String,
        location: json['location'] as String,
        lines: (json['lines'] as List<dynamic>)
            .map((lineJson) => DeliveryLine.fromJson(lineJson as Map<String, dynamic>))
            .toList(),
        status: DeliveryStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => DeliveryStatus.pending),
        createdById: json['createdById'] as String,
        createdByName: json['createdByName'] as String,
        assignedDriverId: json['assignedDriverId'] as String?,
        assignedDriverName: json['assignedDriverName'] as String?,
        createdAt: json['createdAt'] as Timestamp,
        inTransitAt: json['inTransitAt'] as Timestamp?,
        deliveredAt: json['deliveredAt'] as Timestamp?,
        statusHistory: (json['statusHistory'] as List<dynamic>?)?.cast<Map<String, dynamic>>(),
        clientSignatureBase64: json['clientSignatureBase64'] as String?,
        photoBase64: json['photoBase64'] as String?,
      );
}