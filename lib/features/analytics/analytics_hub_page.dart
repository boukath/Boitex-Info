// lib/features/analytics/analytics_hub_page.dart
import 'package:boitex_info/features/analytics/installation_analytics_page.dart';
import 'package:boitex_info/features/analytics/intervention_analytics_page.dart';
import 'package:boitex_info/features/analytics/livraison_analytics_page.dart';
import 'package:boitex_info/features/analytics/sav_analytics_page.dart';
import 'package:flutter/material.dart';

class AnalyticsHubPage extends StatelessWidget {
  const AnalyticsHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Hub'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAnalyticsCard(
            context: context,
            title: 'Intervention Analytics',
            subtitle: 'View stats on tickets, priority, and status',
            icon: Icons.build_circle_outlined,
            color: Colors.indigo,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InterventionAnalyticsPage()),
              );
            },
          ),
          _buildAnalyticsCard(
            context: context,
            title: 'Installation Analytics',
            subtitle: 'Track progress and completion rates',
            icon: Icons.add_home_work_outlined,
            color: Colors.teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InstallationAnalyticsPage()),
              );
            },
          ),
          _buildAnalyticsCard(
            context: context,
            title: 'SAV Analytics',
            subtitle: 'Analyze repair backlogs and turnaround times',
            icon: Icons.construction_outlined,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SavAnalyticsPage()),
              );
            },
          ),
          _buildAnalyticsCard(
            context: context,
            title: 'Livraison Analytics',
            subtitle: 'Monitor delivery statuses and schedules',
            icon: Icons.local_shipping_outlined,
            color: Colors.blueGrey,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LivraisonAnalyticsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({
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