import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/pdf_utils.dart' show toB64;
import '../../models/interventions_models.dart';

class FsCodeCounter {
  final FirebaseFirestore _db;
  FsCodeCounter(this._db);

  Future<String> next(String prefix) async {
    final ref = _db.collection('counters').doc(prefix);
    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      int next = (snap.data()?['next'] as int?) ?? 1;
      tx.set(ref, {'next': next + 1}, SetOptions(merge: true));
      return '$prefix$next';
    });
  }

  Future<String> peek(String prefix) async {
    final snap = await _db.collection('counters').doc(prefix).get();
    final next = (snap.data()?['next'] as int?) ?? 1;
    return '$prefix$next';
  }
}

class InterventionsRepoFirebase {
  final FirebaseFirestore _db;
  final FsCodeCounter _counter;
  InterventionsRepoFirebase(FirebaseFirestore db)
      : _db = db,
        _counter = FsCodeCounter(db);

  Future<String> peekNextCode() => _counter.peek('INT');
  Future<String> nextCode() => _counter.next('INT');

  Future<void> addRequest(InterventionRequest r) async {
    await _db.collection('interventions').doc(r.code).set({
      'code': r.code,
      'clientName': r.clientName,
      'date': Timestamp.fromDate(r.date),
      'phone': r.phone,
      'location': r.location,
      'issue': r.issue,
      'level': r.level,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addReport({
    required String code,
    required String technician,
    required String manager,
    required DateTime arrive,
    required DateTime depart,
    required String modelType,
    required String diagnosis,
    required String reparation,
    Uint8List? signaturePng,
  }) async {
    await _db.collection('interventions').doc(code).collection('reports').add({
      'technician': technician,
      'manager': manager,
      'arrive': Timestamp.fromDate(arrive),
      'depart': Timestamp.fromDate(depart),
      'modelType': modelType,
      'diagnosis': diagnosis,
      'reparation': reparation,
      'signatureBase64': toB64(signaturePng),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<InterventionRequest>> streamAll() {
    return _db.collection('interventions').orderBy('date', descending: true).snapshots().map((q) {
      return q.docs.map((d) {
        final m = d.data();
        return InterventionRequest()
          ..code = m['code'] as String
          ..clientName = (m['clientName'] as String?) ?? ''
          ..date = (m['date'] as Timestamp).toDate()
          ..phone = (m['phone'] as String?) ?? ''
          ..location = (m['location'] as String?) ?? ''
          ..issue = (m['issue'] as String?) ?? ''
          ..level = (m['level'] as String?) ?? 'Green';
      }).toList();
    });
  }

  Future<List<InterventionRequest>> filtered({
    String? clientSub,
    DateTime? from,
    DateTime? to,
  }) async {
    final q = await _db.collection('interventions').orderBy('date', descending: true).limit(500).get();
    final all = q.docs.map((d) {
      final m = d.data();
      return InterventionRequest()
        ..code = m['code'] as String
        ..clientName = (m['clientName'] as String?) ?? ''
        ..date = (m['date'] as Timestamp).toDate()
        ..phone = (m['phone'] as String?) ?? ''
        ..location = (m['location'] as String?) ?? ''
        ..issue = (m['issue'] as String?) ?? ''
        ..level = (m['level'] as String?) ?? 'Green';
    }).toList();

    return all.where((i) {
      final okClient = (clientSub == null || clientSub.isEmpty) ||
          i.clientName.toLowerCase().contains(clientSub.toLowerCase());
      final okFrom = from == null || !i.date.isBefore(DateTime(from.year, from.month, from.day));
      final okTo = to == null || !i.date.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59));
      return okClient && okFrom && okTo;
    }).toList();
  }

  Future<Map<String, dynamic>?> fetchReportFor(String code) async {
    final q = await _db.collection('interventions').doc(code).collection('reports')
      .orderBy('createdAt', descending: true).limit(1).get();
    return q.docs.isEmpty ? null : q.docs.first.data();
  }
}
