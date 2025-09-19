// lib/features/analytics/sav_analytics_page.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/repairs_sav_domain.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavAnalyticsPage extends ConsumerWidget {
  const SavAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backlogTrendAsync = ref.watch(savBacklogTrendProvider);
    final statusAsync = ref.watch(savStatusProvider);
    final commonFaultsAsync = ref.watch(savCommonFaultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SAV Analytics'),
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
                      const Text('Repair Backlog Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: backlogTrendAsync.when(
                          data: (data) => _buildLineChart(data),
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
            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tickets by Current Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: statusAsync.when(
                          data: (data) => _buildStatusBarChart(data),
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
            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Most Common Faults', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: commonFaultsAsync.when(
                          data: (data) => _buildHorizontalBarChart(data),
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

  Widget _buildLineChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No backlog data available.'));

    final spots = data.entries.toList()
        .asMap().entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value.toDouble()))
        .toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= data.keys.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(data.keys.toList()[index], style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                );
              },
              interval: 1,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBarChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No tickets in progress.'));

    final colors = {
      SavStatus.New.name: Colors.grey.shade500,
      SavStatus.Assigned.name: Colors.purple.shade400,
      SavStatus.Diagnosing.name: Colors.blue.shade400,
      SavStatus.AwaitingParts.name: Colors.orange.shade400,
      SavStatus.RepairInProgress.name: Colors.lightBlue.shade300,
      SavStatus.Repaired.name: Colors.green.shade400,
    };
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
                color: colors[value.key] ?? Colors.grey,
                width: 22,
                borderRadius: BorderRadius.circular(6),
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
                final key = entries[index].key;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(key, style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalBarChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No fault data available.'));

    final entries = data.entries.toList()..sort((a,b) => b.value.compareTo(a.value));
    final top5 = entries.take(5).toList();

    return BarChart(
      BarChartData(
        barGroups: top5.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.value.toDouble(),
                color: Colors.red.shade400,
                width: 16,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 120,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= top5.length) return const SizedBox.shrink();
                final faultName = top5[value.toInt()].key;
                return Text(
                  faultName,
                  style: const TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= top5.length) return const SizedBox.shrink();
                return Text(top5[value.toInt()].value.toString(), style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}