// lib/features/analytics/intervention_analytics_page.dart
import 'package:boitex_info/features/analytics/resolution_analytics.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InterventionAnalyticsPage extends ConsumerWidget {
  const InterventionAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(analyticsDateRangeProvider);

    final priorityAsync = ref.watch(interventionPriorityProvider(dateRange));
    final statusAsync = ref.watch(interventionStatusDistributionProvider(dateRange));
    final resolutionAsync = ref.watch(resolutionTimeAnalyticsProvider(dateRange));
    final leaderboardAsync = ref.watch(technicianLeaderboardProvider(dateRange));
    final commonIssuesAsync = ref.watch(commonIssuesProvider(dateRange));

    return Scaffold(
      appBar: AppBar(title: const Text('Intervention Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Selected Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${DateFormat.yMMMd().format(dateRange.start)} - ${DateFormat.yMMMd().format(dateRange.end)}'),
                onTap: () async {
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    initialDateRange: dateRange,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    ref.read(analyticsDateRangeProvider.notifier).state = picked;
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            const Text('Resolution Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            resolutionAsync.when(
              data: (analytics) => Row(
                children: [
                  Expanded(child: _buildStatCard('Average', _formatDuration(analytics.average), Icons.timelapse, Colors.indigo)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Fastest', _formatDuration(analytics.fastest), Icons.rocket_launch, Colors.green)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard('Slowest', _formatDuration(analytics.slowest), Icons.hourglass_bottom, Colors.red)),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: ${e.toString()}', textAlign: TextAlign.center)),
            ),
            const SizedBox(height: 24),

            const Text('Most Common Issues', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                  child: commonIssuesAsync.when(
                    data: (data) => _buildHorizontalBarChart(data),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e,s) => const Center(child: Text('Error')),
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
                      const Text('By Priority Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: priorityAsync.when(
                          data: (data) => _buildPieChart(data),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => const Center(child: Text('Error')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('By Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: statusAsync.when(
                          data: (data) => _buildBarChart(data),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => const Center(child: Text('Error')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text('Performance Leaderboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: leaderboardAsync.when(
                data: (leaderboard) {
                  if (leaderboard.isEmpty) {
                    return const ListTile(title: Text('No resolved tickets with assigned technicians yet.'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: leaderboard.length,
                    itemBuilder: (context, index) {
                      final entry = leaderboard[index];
                      final rank = index + 1;
                      IconData rankIcon = Icons.military_tech_outlined;
                      Color rankColor = Colors.grey;
                      if (rank == 1) { rankColor = Colors.amber; }
                      if (rank == 2) { rankColor = Colors.grey.shade400; }
                      if (rank == 3) { rankColor = Colors.brown.shade400; }

                      return ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('#$rank', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Icon(rankIcon, color: rankColor),
                          ],
                        ),
                        title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text(
                          entry.value.toString(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: ${e.toString()}', textAlign: TextAlign.center)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: Colors.grey.shade700)),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
    if (duration.inHours > 0) return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    if (duration.inMinutes > 0) return '${duration.inMinutes}m';
    return '${duration.inSeconds}s';
  }

  Widget _buildHorizontalBarChart(List<MapEntry<String, int>> data) {
    if (data.isEmpty) return const Center(child: Text('No data'));

    return BarChart(
      BarChartData(
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.value.toDouble(),
                color: Colors.teal,
                width: 16,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
              ),
            ],
            showingTooltipIndicators: [0],
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
                if (value.toInt() >= data.length) return const SizedBox.shrink();
                final issue = data[value.toInt()].key;
                return Text(
                  issue,
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
                return Text(meta.formattedValue, style: const TextStyle(fontSize: 10));
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
      swapAnimationDuration: const Duration(milliseconds: 150),
      swapAnimationCurve: Curves.linear,
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    final colors = {
      'Red': Colors.red.shade400,
      'Yellow': Colors.amber.shade400,
      'Green': Colors.green.shade400,
    };
    final total = data.values.fold(0, (a, b) => a + b);

    if (total == 0) return const Center(child: Text('No data'));

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

  Widget _buildBarChart(Map<String, int> data) {
    final colors = {
      'New': Colors.grey.shade500,
      'Assigned': Colors.purple.shade400,
      'InProgress': Colors.blue.shade400,
      'OnHold': Colors.amber.shade500,
      'Resolved': Colors.green.shade500,
    };

    if (data.isEmpty) return const Center(child: Text('No data'));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: data.entries.map((entry) {
          int index = data.keys.toList().indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: colors[entry.key] ?? Colors.grey,
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
                if (value.toInt() >= data.keys.length) return const SizedBox.shrink();
                final key = data.keys.toList()[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(key, style: const TextStyle(fontSize: 12)),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}