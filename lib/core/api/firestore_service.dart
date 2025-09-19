// lib/core/api/firestore_service.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  // Stream a user's profile from the 'users' collection using their UID
  Stream<BoitexUser> userStream({required String uid}) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) => BoitexUser.fromFirestore(snapshot));
  }
}