// lib/features/analytics/livraison_analytics_page.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LivraisonAnalyticsPage extends ConsumerWidget {
  const LivraisonAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(deliveryStatusProvider);
    final monthlyAsync = ref.watch(monthlyDeliveriesProvider); // Watch the new provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Livraison Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Deliveries by Current Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: statusAsync.when(
                          data: (data) => _buildPieChart(data),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => const Center(child: Text('Error loading chart data')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // New Monthly Delivery Trend Chart
            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Monthly Trend (Last 12 Months)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: monthlyAsync.when(
                          data: (data) => _buildMonthlyBarChart(data),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => const Center(child: Text('Error loading chart data')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    final colors = {
      DeliveryStatus.pending.name: Colors.amber.shade400,
      DeliveryStatus.inTransit.name: Colors.blue.shade400,
      DeliveryStatus.delivered.name: Colors.green.shade400,
      DeliveryStatus.cancelled.name: Colors.red.shade400,
    };
    final total = data.values.fold(0, (a, b) => a + b);

    if (total == 0) return const Center(child: Text('No delivery data available.'));

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        sections: data.entries.map((entry) {
          final percentage = (entry.value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            color: colors[entry.key] ?? Colors.grey,
            value: entry.value.toDouble(),
            title: '${entry.value}\n($percentage%)',
            radius: 60,
            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }

  // New helper for the Monthly Trend Bar Chart
  Widget _buildMonthlyBarChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No data'));

    final entries = data.entries.toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: entries.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.value.toDouble(),
                color: Colors.blueGrey,
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= entries.length) return const SizedBox.shrink();
                final key = entries[index].key; // e.g., "Sep 2025"
                final month = key.split(' ')[0]; // "Sep"
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(month, style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}