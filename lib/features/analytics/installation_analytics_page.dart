// lib/features/analytics/installation_analytics_page.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/installation_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

class InstallationAnalyticsPage extends ConsumerWidget {
  const InstallationAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final successRateAsync = ref.watch(installationSuccessRateProvider);
    final totalAsync = ref.watch(totalInstallationsProvider);
    final completedAsync = ref.watch(completedInstallationsProvider);
    final statusAsync = ref.watch(installationStatusProvider);
    final monthlyAsync = ref.watch(monthlyInstallationsProvider);
    final typesAsync = ref.watch(installationTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: SizedBox(
                height: 300,
                child: successRateAsync.when(
                  data: (rate) => _buildGauge(rate),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e,s) => const Center(child: Text('Error loading rate')),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('Completed'),
                      trailing: Text(
                        completedAsync.when(data: (d) => d.toString(), error: (e,s) => '!', loading: () => '...'),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: ListTile(
                      title: const Text('Total'),
                      trailing: Text(
                        totalAsync.when(data: (d) => d.toString(), error: (e,s) => '!', loading: () => '...'),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
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
                      const Text('Installations by Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 24),

            SizedBox(
              height: 300,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Installations by Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Expanded(
                        child: typesAsync.when(
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

  Widget _buildGauge(double rate) {
    return SfRadialGauge(
      title: const GaugeTitle(text: 'Success Rate', textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: Colors.black12,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: rate,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
              color: Colors.green,
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              positionFactor: 0.1,
              angle: 90,
              widget: Text(
                '${rate.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    final colors = {
      InstallationStatus.New.name: Colors.grey.shade500,
      InstallationStatus.Assigned.name: Colors.purple.shade400,
      InstallationStatus.InProgress.name: Colors.blue.shade400,
      InstallationStatus.OnHold.name: Colors.amber.shade500,
      InstallationStatus.Completed.name: Colors.green.shade500,
    };
    final total = data.values.fold(0, (a, b) => a + b);

    if (total == 0) return const Center(child: Text('No installation data'));

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        sections: data.entries.map((entry) {
          final percentage = (entry.value / total * 100).toStringAsFixed(1);
          return PieChartSectionData(
            color: colors[entry.key] ?? Colors.black,
            value: entry.value.toDouble(),
            title: '${entry.value}\n($percentage%)',
            radius: 60,
            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList(),
      ),
    );
  }

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
                color: Colors.teal,
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
                final key = entries[index].key;
                final month = key.split(' ')[0];
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

  Widget _buildHorizontalBarChart(Map<String, int> data) {
    if (data.isEmpty) return const Center(child: Text('No data'));

    final entries = data.entries.toList()..sort((a,b) => b.value.compareTo(a.value));

    return BarChart(
      BarChartData(
        barGroups: entries.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value.value.toDouble(),
                color: Colors.indigo,
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
              reservedSize: 100,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= entries.length) return const SizedBox.shrink();
                final typeName = entries[value.toInt()].key;
                return Text(
                  typeName,
                  style: const TextStyle(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() >= entries.length) return const SizedBox.shrink();
                return Text(entries[value.toInt()].value.toString(), style: const TextStyle(fontSize: 10));
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