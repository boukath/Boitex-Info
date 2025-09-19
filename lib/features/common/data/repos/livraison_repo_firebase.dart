import 'package:cloud_firestore/cloud_firestore.dart';

class LivraisonRepoFirebase {
  final FirebaseFirestore _db;
  LivraisonRepoFirebase(this._db);

  Future<String> _nextCode() async {
    final ref = _db.collection('counters').doc('BL');
    return _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      int next = (snap.data()?['next'] as int?) ?? 1;
      tx.set(ref, {'next': next + 1}, SetOptions(merge: true));
      return 'BL' + next.toString();
    });
  }

  Future<String> peekNextCode() async {
    final snap = await _db.collection('counters').doc('BL').get();
    final next = (snap.data()?['next'] as int?) ?? 1;
    return 'BL' + next.toString();
  }

  Future<String> upsertHeader({
    String? code,
    required DateTime date,
    required String clientName,
    String? phone,
    String? location,
  }) async {
    final c = code ?? await _nextCode();
    await _db.collection('livraison').doc(c).set({
      'code': c,
      'date': Timestamp.fromDate(date),
      'clientName': clientName,
      'phone': phone,
      'location': location,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return c;
  }

  Future<String> addLine({
    required String code,
    required String article,
    required int qty,
    double? price,
  }) async {
    final ref = await _db.collection('livraison').doc(code).collection('lines').add({
      'article': article,
      'qty': qty,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> updateLine({
    required String code,
    required String lineId,
    String? article,
    int? qty,
    double? price,
  }) async {
    final patch = <String, dynamic>{};
    if (article != null) patch['article'] = article;
    if (qty != null) patch['qty'] = qty;
    if (price != null) patch['price'] = price;
    await _db.collection('livraison').doc(code).collection('lines').doc(lineId).set(patch, SetOptions(merge: true));
  }

  Future<void> deleteLine({required String code, required String lineId}) async {
    await _db.collection('livraison').doc(code).collection('lines').doc(lineId).delete();
  }

  Future<Map<String, dynamic>?> getHeader(String code) async {
    final doc = await _db.collection('livraison').doc(code).get();
    return doc.data();
  }

  Future<List<Map<String, dynamic>>> getLines(String code) async {
    final q = await _db.collection('livraison').doc(code).collection('lines').orderBy('createdAt').get();
    return q.docs.map((d) => d.data()).toList();
  }

  Future<double> computeTotal(String code) async {
    final lines = await getLines(code);
    double t = 0;
    for (final l in lines) {
      final qty = (l['qty'] as num?)?.toDouble() ?? 0;
      final price = (l['price'] as num?)?.toDouble();
      if (qty > 0 && price != null) t += qty * price;
    }
    return t;
  }

  Stream<List<Map<String, dynamic>>> streamHeaders() {
    return _db.collection('livraison').orderBy('date', descending: true).snapshots()
      .map((q) => q.docs.map((d) => d.data()).toList());
  }

  Future<List<Map<String, dynamic>>> filtered({
    String? clientSub,
    DateTime? from,
    DateTime? to,
  }) async {
    final q = await _db.collection('livraison').orderBy('date', descending: true).limit(500).get();
    final all = q.docs.map((d) => d.data()).toList();
    return all.where((m) {
      final name = (m['clientName'] as String?) ?? '';
      final dt = (m['date'] as Timestamp).toDate();
      final okClient = (clientSub == null || clientSub.isEmpty) ||
          name.toLowerCase().contains(clientSub.toLowerCase());
      final okFrom = from == null || !dt.isBefore(DateTime(from.year, from.month, from.day));
      final okTo = to == null || !dt.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59));
      return okClient && okFrom && okTo;
    }).toList();
  }

  Future<void> deleteHeader(String code) async {
    final q = await _db.collection('livraison').doc(code).collection('lines').get();
    for (final d in q.docs) {
      await d.reference.delete();
    }
    await _db.collection('livraison').doc(code).delete();
  }
}
