// lib/features/sections/livraison_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'livraison_domain.dart';
import 'package:boitex_info/services/notification_service.dart';

class LivraisonService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final CollectionReference<DeliveryNote> _notesRef;
  late final DocumentReference _counterRef;

  LivraisonService() {
    _notesRef = _db.collection('livraisons').withConverter<DeliveryNote>(
      fromFirestore: (snapshot, _) => DeliveryNote.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (note, _) => note.toJson(),
    );
    _counterRef = _db.collection('counters').doc('livraison');
  }

  Future<void> addLivraison(DeliveryNote note, String userName) async {
    final heading = 'New Delivery Note Created';
    final content = '$userName created delivery note #${note.code} for ${note.client}';
    await NotificationService.sendGlobalNotification(heading, content);
    await _notesRef.add(note);
  }

  Future<void> updateLivraisonStatus(DeliveryNote note, DeliveryStatus newStatus, String userName) async {
    if (note.id == null) throw Exception('Delivery Note must have an ID to be updated.');

    final heading = 'Delivery Status Updated';
    final content = '$userName updated #${note.code} to ${newStatus.name} for ${note.client}';
    await NotificationService.sendGlobalNotification(heading, content);

    final historyEntry = {
      'status': newStatus.name,
      'updatedBy': userName,
      // --- FIXED: Use client-side timestamp for array operations ---
      'timestamp': Timestamp.now(),
    };

    final Map<String, dynamic> updates = {
      'status': newStatus.name,
      'statusHistory': FieldValue.arrayUnion([historyEntry]),
    };

    if (newStatus == DeliveryStatus.inTransit) {
      // This is a top-level field, so serverTimestamp is okay here.
      updates['inTransitAt'] = FieldValue.serverTimestamp();
    }
    return _notesRef.doc(note.id).update(updates);
  }

  Future<void> completeDelivery({
    required String noteId,
    required String noteCode,
    required String clientName,
    required String userName,
    required String signatureBase64,
    String? photoBase64,
  }) async {
    final heading = 'Delivery Completed';
    final content = '$userName completed delivery #${noteCode} for $clientName';
    await NotificationService.sendGlobalNotification(heading, content);

    final historyEntry = {
      'status': DeliveryStatus.delivered.name,
      'updatedBy': userName,
      // --- FIXED: Use client-side timestamp for array operations ---
      'timestamp': Timestamp.now(),
    };

    return _notesRef.doc(noteId).update({
      'status': DeliveryStatus.delivered.name,
      'deliveredAt': FieldValue.serverTimestamp(),
      'clientSignatureBase64': signatureBase64,
      'photoBase64': photoBase64,
      'statusHistory': FieldValue.arrayUnion([historyEntry]),
    });
  }

  Future<String> getNextCode() async {
    try {
      final nextCode = await _db.runTransaction((transaction) async {
        final counterSnap = await transaction.get(_counterRef);
        final data = counterSnap.data() as Map<String, dynamic>?;
        final currentCount = (data?['count'] as int?) ?? 0;
        final nextCount = currentCount + 1;
        transaction.set(_counterRef, {'count': nextCount}, SetOptions(merge: true));
        return 'BL-${nextCount.toString().padLeft(3, '0')}';
      });
      return nextCode;
    } catch (e) {
      return 'BL-ERR${DateTime.now().millisecondsSinceEpoch % 10000}';
    }
  }
}