import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

/// Registration has been disabled for this app.
class RegisterPage extends StatelessWidget {
  final AuthRepository auth;
  const RegisterPage({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration disabled')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Admin-managed users only. Please contact your administrator.'),
        ),
      ),
    );
  }
}
