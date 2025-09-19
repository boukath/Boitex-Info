// lib/features/analytics/analytics_page.dart

import 'package:boitex_info/common/ui/app_background.dart';
import 'package:boitex_info/features/sections/installation_service.dart';
import 'package:boitex_info/features/sections/intervention_service.dart';
import 'package:boitex_info/features/sections/repairs_sav_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  Future<Map<String, int>>? _activityCountsFuture;

  @override
  void initState() {
    super.initState();
    _setToThisMonth();
  }

  void _fetchAnalyticsData() {
    setState(() {
      _activityCountsFuture = _getActivityCounts(_startDate, _endDate);
    });
  }

  Future<Map<String, int>> _getActivityCounts(DateTime start, DateTime end) async {
    final interventionCount = await InterventionService().getCountInDateRange(start, end);
    final installationCount = await InstallationService().getCountInDateRange(start, end);
    final savCount = await SavService().getCountInDateRange(start, end);
    return {
      'Interventions': interventionCount,
      'Installations': installationCount,
      'SAV': savCount,
    };
  }

  void _setToThisMonth() {
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    _fetchAnalyticsData();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Reporting & Analytics')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Activity Breakdown (This Month)', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FutureBuilder<Map<String, int>>(
                      future: _activityCountsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Could not load data.'));
                        }

                        final counts = snapshot.data!;
                        final total = counts.values.reduce((a, b) => a + b);
                        if (total == 0) {
                          return const Center(child: Text('No activity in this period.'));
                        }

                        return PieChart(
                          PieChartData(
                            sections: _buildPieChartSections(counts, total),
                            centerSpaceRadius: 60,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(Map<String, int> counts, int total) {
    final colors = [Colors.orange, Colors.cyan, Colors.blue];
    int colorIndex = 0;

    return counts.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      final color = colors[colorIndex++ % colors.length];

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 80,
        badgeWidget: _Badge(entry.key, color: color),
        badgePositionPercentageOffset: 0.98,
      );
    }).toList();
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}