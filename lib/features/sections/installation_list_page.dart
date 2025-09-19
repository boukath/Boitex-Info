// lib/features/sections/installation_list_page.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/installation_completion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'installation_domain.dart';
import 'installation_report_view_page.dart';

class InstallationListPage extends ConsumerWidget {
  const InstallationListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeInstallationsAsync = ref.watch(activeInstallationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Installations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: activeInstallationsAsync.when(
        data: (installations) {
          if (installations.isEmpty) {
            return const Center(child: Text('There are no active installations.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: installations.length,
            itemBuilder: (context, index) {
              final installation = installations[index];
              // --- The custom _InstallationCard now handles the new design ---
              return _InstallationCard(installation: installation);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load installations.')),
      ),
    );
  }
}

// --- NEW: A dedicated, redesigned card widget ---
class _InstallationCard extends StatelessWidget {
  final Installation installation;

  const _InstallationCard({required this.installation});

  // Helper to get the flag color based on priority level
  Color _getFlagColor(String level) {
    switch (level) {
      case 'Red':
      case 'High Urgent':
        return Colors.red.shade400;
      case 'Yellow':
      case 'Medium':
        return Colors.amber.shade700;
      default:
        return Colors.green.shade400;
    }
  }

  // Helper to get the status color
  Color _getStatusColor(InstallationStatus status) {
    return switch (status) {
      InstallationStatus.New => Colors.orange.shade400,
      InstallationStatus.Assigned => Colors.blue.shade400,
      InstallationStatus.InProgress => Colors.purple.shade400,
      InstallationStatus.OnHold => Colors.grey.shade600,
      InstallationStatus.Completed => Colors.green.shade500,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Colors.grey.shade600;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (installation.status == InstallationStatus.Completed) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => InstallationReportViewPage(installation: installation)));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => InstallationCompletionPage(installation: installation)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ADDED: Priority Flag ---
                  Icon(Icons.flag_rounded, color: _getFlagColor(installation.level), size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          installation.clientName,
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Model: ${installation.modelType}',
                          style: textTheme.bodyMedium?.copyWith(color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // --- IMPROVED: Status Chip ---
                  Chip(
                    label: Text(installation.status.name),
                    backgroundColor: _getStatusColor(installation.status).withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: _getStatusColor(installation.status),
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: secondaryColor),
                  const SizedBox(width: 6),
                  Text(DateFormat.yMMMd().format(installation.date), style: TextStyle(color: secondaryColor, fontSize: 12)),
                  const SizedBox(width: 12),
                  const Text('•', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 12),
                  Icon(Icons.location_on, size: 14, color: secondaryColor),
                  const SizedBox(width: 6),
                  Expanded(child: Text(installation.storeLocation, overflow: TextOverflow.ellipsis, style: TextStyle(color: secondaryColor, fontSize: 12))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}