import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/roles.dart';
import '../models/boitex_user.dart';
import 'auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  @override
  Stream<BoitexUser?> authStateChanges() {
    return _auth.authStateChanges().asyncMap(_userFromFirebase);
  }

  @override
  Future<BoitexUser?> currentUser() {
    // This method is now used by main.dart on startup
    return _userFromFirebase(_auth.currentUser);
  }

  @override
  Future<BoitexUser?> signIn({required String email, required String password}) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(cred.user);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<BoitexUser?> _userFromFirebase(User? u) async {
    if (u == null) return null;
    try {
      final doc = await _users.doc(u.uid).get();
      if (doc.exists) {
        return BoitexUser.fromFirestore(doc);
      } else {
        // Fallback if user exists in Auth but not in Firestore DB
        return BoitexUser(
            uid: u.uid,
            email: u.email ?? '',
            // FIX: Provide a default fullName to prevent errors
            fullName: u.displayName ?? 'New User',
            role: UserRole.viewer);
      }
    } catch (e) {
      print('Error getting user profile: $e');
      // Fallback on any error
      return BoitexUser(
          uid: u.uid,
          email: u.email ?? '',
          fullName: u.displayName ?? 'Error User',
          role: UserRole.viewer);
    }
  }
}