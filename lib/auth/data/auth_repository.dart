// lib/auth/data/auth_repository.dart
import '../models/boitex_user.dart';

abstract class AuthRepository {
  Stream<BoitexUser?> authStateChanges();
  Future<BoitexUser?> currentUser();
  Future<BoitexUser?> signIn({required String email, required String password});
  Future<void> signOut();

  /// Needed by Login page "Forgot password"
  Future<void> sendPasswordResetEmail(String email);
}