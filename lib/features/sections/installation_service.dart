// lib/features/sections/installation_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:boitex_info/services/notification_service.dart';
import 'installation_domain.dart';

class InstallationService {
  final _db = FirebaseFirestore.instance;
  late final CollectionReference<Installation> _installationsRef;
  late final DocumentReference _counterRef;

  InstallationService() {
    _installationsRef = _db.collection('installations').withConverter<Installation>(
      fromFirestore: (snapshot, _) => Installation.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (installation, _) => installation.toJson(),
    );
    _counterRef = _db.collection('counters').doc('installations');
  }

  // MODIFIED: Added userName parameter and notification logic
  Future<void> addInstallation(Installation installation, String userName) async {
    final heading = 'New Installation Created';
    final content = '$userName created #${installation.code} for ${installation.clientName}';
    await NotificationService.sendGlobalNotification(heading, content);

    await _installationsRef.add(installation);
  }

  // MODIFIED: Notification now sent on EVERY update, not just 'Completed'
  Future<void> updateInstallation(Installation installation, String userName) async {
    if (installation.id == null) throw Exception('Installation must have an ID to be updated.');

    final heading = 'Installation Updated';
    final content = '$userName updated #${installation.code} to status: ${installation.status.name}';
    await NotificationService.sendGlobalNotification(heading, content);

    return _installationsRef.doc(installation.id).update(installation.toJson());
  }

  Future<String> getNextCode() async {
    try {
      final nextCode = await _db.runTransaction((transaction) async {
        final counterSnap = await transaction.get(_counterRef);
        final data = counterSnap.data() as Map<String, dynamic>?;
        final currentCount = (data?['count'] as int?) ?? 0;
        final nextCount = currentCount + 1;
        transaction.set(_counterRef, {'count': nextCount}, SetOptions(merge: true));
        return 'INS$nextCount';
      });
      return nextCode;
    } catch (e) {
      return 'INS-ERR${DateTime.now().millisecondsSinceEpoch % 10000}';
    }
  }
}