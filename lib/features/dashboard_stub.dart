import 'package:flutter/material.dart';
import '../auth/data/auth_repository.dart';
import '../core/roles.dart';
import '../auth/presentation/login_page.dart';

class DashboardStub extends StatelessWidget {
  final AuthRepository auth;
  const DashboardStub({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boitex-Info Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage(auth: auth)),
                  (route) => false,
                );
              }
            },
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello, ${user.fullName}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text('Role: ${user.role.label}'),
            const Divider(height: 32),
            Text('Access Summary', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              Chip(label: Text('Interventions: ${user.role.canEditTechOps ? 'Edit' : 'View'}')),
              Chip(label: Text('Installations: ${user.role.canEditTechOps ? 'Edit' : 'View'}')),
              Chip(label: Text('Repairs & SAV: ${user.role.canEditTechOps ? 'Edit' : 'View'}')),
              Chip(label: Text('Livraison (Sales): ${user.role.canEditLivraison ? 'Edit' : 'View'}')),
            ]),
            const SizedBox(height: 24),
            const Text('→ Replace this page with your real dashboards next.'),
          ],
        ),
      ),
    );
  }
}
