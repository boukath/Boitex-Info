// lib/auth/models/boitex_user.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/roles.dart';

class BoitexUser {
  final String uid;
  final String? email;
  final String fullName;
  final UserRole role;

  const BoitexUser({
    required this.uid,
    this.email,
    required this.fullName,
    required this.role,
  });

  factory BoitexUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BoitexUser(
      uid: doc.id,
      email: data['email'] as String?,
      fullName: data['fullName'] as String? ?? 'No Name',
      role: parseRole(data['role'] as String?),
    );
  }
}