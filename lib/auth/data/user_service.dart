// lib/auth/data/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/boitex_user.dart';

class UserService {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  /// Fetches a list of all users from the Firestore 'users' collection.
  Future<List<BoitexUser>> getAllUsers() async {
    try {
      final snapshot = await _usersCollection.get();
      // Convert each document into a BoitexUser object
      return snapshot.docs
          .map((doc) => BoitexUser.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error fetching users: $e');
      return []; // Return an empty list on error
    }
  }
}