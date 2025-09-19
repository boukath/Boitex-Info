import 'package:cloud_firestore/cloud_firestore.dart';

class SavRepoFirebase {
  final FirebaseFirestore _db;
  SavRepoFirebase(this._db);

  Future<String> _nextCode() async {
    final ref = _db.collection('counters').doc('SAV');
    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      int next = (snap.data()?['next'] as int?) ?? 1;
      tx.set(ref, {'next': next + 1}, SetOptions(merge: true));
      return 'SAV' + next.toString();
    });
  }

  Future<String> peekNextCode() async {
    final snap = await _db.collection('counters').doc('SAV').get();
    final next = (snap.data()?['next'] as int?) ?? 1;
    return 'SAV' + next.toString();
  }

  Future<String> addEntry({
    String? code,
    required DateTime date,
    required String client,
    DateTime? arrivalDate,
    DateTime? returnDate,
    required String diagnostic,
    required String repair,
    String? partChanged,
  }) async {
    final c = code ?? await _nextCode();
    await _db.collection('sav').doc(c).set({
      'code': c,
      'date': Timestamp.fromDate(date),
      'client': client,
      'arrivalDate': arrivalDate != null ? Timestamp.fromDate(arrivalDate) : null,
      'returnDate': returnDate != null ? Timestamp.fromDate(returnDate) : null,
      'diagnostic': diagnostic,
      'repair': repair,
      'partChanged': partChanged,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return c;
  }

  Future<void> updateEntry(String code, Map<String, dynamic> patch) async {
    if (patch.containsKey('date') && patch['date'] is DateTime) {
      patch['date'] = Timestamp.fromDate(patch['date'] as DateTime);
    }
    if (patch.containsKey('arrivalDate') && patch['arrivalDate'] is DateTime) {
      patch['arrivalDate'] = Timestamp.fromDate(patch['arrivalDate'] as DateTime);
    }
    if (patch.containsKey('returnDate') && patch['returnDate'] is DateTime) {
      patch['returnDate'] = Timestamp.fromDate(patch['returnDate'] as DateTime);
    }
    await _db.collection('sav').doc(code).set(patch, SetOptions(merge: true));
  }

  Stream<List<Map<String, dynamic>>> streamAll() {
    return _db.collection('sav').orderBy('date', descending: true).snapshots().map(
      (q) => q.docs.map((d) => d.data()).toList(),
    );
  }

  Future<List<Map<String, dynamic>>> filtered({
    String? clientSub,
    DateTime? from,
    DateTime? to,
  }) async {
    final q = await _db.collection('sav').orderBy('date', descending: true).limit(500).get();
    final all = q.docs.map((d) => d.data()).toList();
    return all.where((m) {
      final clientName = (m['client'] as String?) ?? '';
      final dt = (m['date'] as Timestamp).toDate();
      final okClient = (clientSub == null || clientSub.isEmpty) ||
          clientName.toLowerCase().contains(clientSub.toLowerCase());
      final okFrom = from == null || !dt.isBefore(DateTime(from.year, from.month, from.day));
      final okTo = to == null || !dt.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59));
      return okClient && okFrom && okTo;
    }).toList();
  }

  Future<Map<String, dynamic>?> getByCode(String code) async {
    final doc = await _db.collection('sav').doc(code).get();
    return doc.data();
  }

  Future<void> deleteByCode(String code) async {
    await _db.collection('sav').doc(code).delete();
  }
}
