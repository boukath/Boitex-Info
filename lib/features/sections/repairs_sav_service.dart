// lib/features/sections/repairs_sav_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'repairs_sav_domain.dart';
import 'package:boitex_info/services/notification_service.dart';


class SavService {
  final _db = FirebaseFirestore.instance;
  late final CollectionReference<SavTicket> _ticketsRef;
  late final DocumentReference _counterRef;

  SavService() {
    _ticketsRef = _db.collection('sav_tickets').withConverter<SavTicket>(
      fromFirestore: (snapshot, _) => SavTicket.fromJson(snapshot.data()!, snapshot.id),
      toFirestore: (ticket, _) => ticket.toJson(),
    );
    _counterRef = _db.collection('counters').doc('sav_tickets');
  }

  Stream<List<SavTicket>> getTicketsStream() {
    final query = _ticketsRef.orderBy('date', descending: true);
    return query.snapshots().map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // MODIFIED: Added userName parameter and notification logic
  Future<void> addTicket(SavTicket ticket, String userName) async {
    final heading = 'New SAV Ticket Created';
    final content = '$userName created SAV Ticket #${ticket.code} for ${ticket.client}';
    await NotificationService.sendGlobalNotification(heading, content);

    await _ticketsRef.add(ticket);
  }

  // MODIFIED: Notification now sent on EVERY update, not just 'ReturnedToClient'
  Future<void> updateTicket(SavTicket ticket, String userName) async {
    if (ticket.id == null) throw Exception('SAV Ticket must have an ID to be updated.');

    final heading = 'SAV Ticket Updated';
    final content = '$userName updated SAV Ticket #${ticket.code} to status: ${ticket.status.name}';
    await NotificationService.sendGlobalNotification(heading, content);

    return _ticketsRef.doc(ticket.id).update(ticket.toJson());
  }

  Future<String> getNextCode() async {
    try {
      final nextCode = await _db.runTransaction((transaction) async {
        final counterSnap = await transaction.get(_counterRef);
        final data = counterSnap.data() as Map<String, dynamic>?;
        final currentCount = (data?['count'] as int?) ?? 0;
        final nextCount = currentCount + 1;
        transaction.set(_counterRef, {'count': nextCount}, SetOptions(merge: true));
        return 'SAV$nextCount';
      });
      return nextCode;
    } catch (e) {
      return 'SAV-ERR${DateTime.now().millisecondsSinceEpoch % 10000}';
    }
  }
}