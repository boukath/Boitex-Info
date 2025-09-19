import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/pdf_utils.dart' show toB64;
import '../../models/installations_models.dart';

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

class InstallationsRepoFirebase {
  final FirebaseFirestore _db;
  final FsCodeCounter _counter;
  InstallationsRepoFirebase(FirebaseFirestore db)
      : _db = db,
        _counter = FsCodeCounter(db);

  Future<String> peekNextCode() => _counter.peek('INS');
  Future<String> nextCode() => _counter.next('INS');

  Future<void> addRequest(InstallationRequest r) async {
    await _db.collection('installations').doc(r.code).set({
      'code': r.code,
      'clientName': r.clientName,
      'date': Timestamp.fromDate(r.date),
      'phone': r.phone,
      'modelType': r.modelType,
      'config': r.config,
      'accessories': r.accessories,
      'level': r.level,
      'comment': r.comment,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addCompletion({
    required String code,
    required DateTime date,
    required String technician,
    required String manager,
    required String modelType,
    required int qty,
    required String accessories,
    required String comment,
    Uint8List? managerSignaturePng,
  }) async {
    await _db.collection('installations').doc(code).collection('completions').add({
      'date': Timestamp.fromDate(date),
      'technician': technician,
      'manager': manager,
      'modelType': modelType,
      'qty': qty,
      'accessories': accessories,
      'comment': comment,
      'managerSignatureBase64': toB64(managerSignaturePng),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> completionFor(String code) async {
    final q = await _db.collection('installations').doc(code).collection('completions')
      .orderBy('createdAt', descending: true).limit(1).get();
    return q.docs.isEmpty ? null : q.docs.first.data();
  }

  Future<List<InstallationRequest>> filtered({
    String? clientSub, DateTime? from, DateTime? to,
  }) async {
    final q = await _db.collection('installations').orderBy('date', descending: true).limit(500).get();
    final all = q.docs.map((d) {
      final m = d.data();
      return InstallationRequest()
        ..code = m['code'] as String
        ..clientName = (m['clientName'] as String?) ?? ''
        ..date = (m['date'] as Timestamp).toDate()
        ..phone = (m['phone'] as String?) ?? ''
        ..modelType = (m['modelType'] as String?) ?? ''
        ..config = (m['config'] as String?) ?? ''
        ..accessories = (m['accessories'] as String?) ?? ''
        ..level = (m['level'] as String?) ?? 'Green'
        ..comment = (m['comment'] as String?) ?? '';
    }).toList();

    return all.where((i) {
      final okClient = (clientSub == null || clientSub.isEmpty) ||
          i.clientName.toLowerCase().contains(clientSub.toLowerCase());
      final okFrom = from == null || !i.date.isBefore(DateTime(from.year, from.month, from.day));
      final okTo = to == null || !i.date.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59));
      return okClient && okFrom && okTo;
    }).toList();
  }
}
