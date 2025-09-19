// lib/features/history/history_hub_page.dart
import 'package:flutter/material.dart';
import 'package:boitex_info/features/history/intervention_history_page.dart';
// --- 1. IMPORT the new Livraison History page ---
import 'package:boitex_info/features/history/livraison_history_page.dart';

class HistoryHubPage extends StatelessWidget {
  const HistoryHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Hub'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildHistoryCard(
            context: context,
            title: 'Intervention History',
            subtitle: 'View all resolved tickets',
            icon: Icons.build_circle_outlined,
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InterventionHistoryPage()),
              );
            },
          ),
          _buildHistoryCard(
            context: context,
            title: 'Installation History',
            subtitle: 'View all completed installations',
            icon: Icons.add_home_work_outlined,
            color: Colors.teal,
            onTap: () {
              // TODO: Create and navigate to InstallationHistoryPage
            },
          ),
          _buildHistoryCard(
            context: context,
            title: 'SAV History',
            subtitle: 'View all returned-to-client repairs',
            icon: Icons.construction_outlined,
            color: Colors.orange,
            onTap: () {
              // TODO: Create and navigate to SavHistoryPage
            },
          ),
          _buildHistoryCard(
            context: context,
            title: 'Livraison History',
            subtitle: 'View all delivered notes',
            icon: Icons.local_shipping_outlined,
            color: Colors.blueGrey,
            // --- 2. UPDATE the onTap to navigate to the new page ---
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LivraisonHistoryPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: CircleAvatar(
          backgroundColor: color,
          foregroundColor: Colors.white,
          child: Icon(icon),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}