// lib/features/dashboard/presentation/widgets/analytics_card_widget.dart
import 'package:boitex_info/features/analytics/analytics_hub_page.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/shared_widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsCardWidget extends ConsumerWidget {
  const AnalyticsCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openTicketsAsync = ref.watch(openTicketsCountProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnalyticsHubPage()),
        );
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(16.0),
        borderRadius: BorderRadius.circular(12),
        // --- FIXED: Gave the card a fixed height to resolve layout errors ---
        child: SizedBox(
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Column(
                children: [
                  openTicketsAsync.when(
                    data: (count) => _buildStatRow('Open Tickets', count.toString(), Colors.blue.shade700),
                    loading: () => const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    error: (e,s) => _buildStatRow('Open Tickets', '!', Colors.red),
                  ),
                  const SizedBox(height: 8),
                  _buildStatRow('Resolved Today', '5', Colors.green.shade700),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'View All Sections',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade700),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(label, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}