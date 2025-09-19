// lib/features/sections/intervention_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'intervention_domain.dart';
import 'package:boitex_info/services/notification_service.dart';

class InterventionService {
  final _db = FirebaseFirestore.instance;
  late final CollectionReference<Intervention> _interventionsRef;
  late final DocumentReference _counterRef;

  InterventionService() {
    _interventionsRef = _db.collection('interventions').withConverter<Intervention>(
      fromFirestore: (snapshot, _) => Intervention.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (intervention, _) => intervention.toJson(),
    );
    _counterRef = _db.collection('counters').doc('interventions');
  }

  // MODIFIED: Added userName parameter and notification logic
  Future<void> addIntervention(Intervention intervention, String userName) async {
    final heading = 'New Intervention Created';
    final content = '$userName created #${intervention.code} for ${intervention.clientName}';
    await NotificationService.sendGlobalNotification(heading, content);

    await _interventionsRef.add(intervention);
  }

  // MODIFIED: Notification now sent on EVERY update, not just 'Resolved'
  Future<void> updateIntervention(Intervention intervention, String userName) async {
    if (intervention.id == null) throw Exception('Intervention must have an ID to be updated.');

    final heading = 'Intervention Updated';
    final content = '$userName updated #${intervention.code} to status: ${intervention.status.name}';
    await NotificationService.sendGlobalNotification(heading, content);

    return _interventionsRef.doc(intervention.id).update(intervention.toJson());
  }

  Future<String> getNextCode() async {
    try {
      final nextCode = await _db.runTransaction((transaction) async {
        final counterSnap = await transaction.get(_counterRef);
        final data = counterSnap.data() as Map<String, dynamic>?;
        final currentCount = (data?['count'] as int?) ?? 0;
        final nextCount = currentCount + 1;
        transaction.set(_counterRef, {'count': nextCount}, SetOptions(merge: true));
        return 'INT$nextCount';
      });
      return nextCode;
    } catch (e) {
      return 'INT-ERR${DateTime.now().millisecondsSinceEpoch % 10000}';
    }
  }
}