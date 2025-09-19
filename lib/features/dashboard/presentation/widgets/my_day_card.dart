import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';

class MyDayCard extends ConsumerWidget {
  const MyDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myDayAsync = ref.watch(myDayProvider);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2.0,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Day (Technician)", // Title can be dynamic based on role
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A202C),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: myDayAsync.when(
                data: (tasks) {
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text("No assignments for today. Enjoy your day! ☀️"),
                    );
                  }
                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      // Assuming 'scheduledDate' is a Firestore Timestamp
                      final scheduledTime = (task['scheduledDate'] as Timestamp).toDate();

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.build_circle_outlined, color: Colors.indigo),
                        title: Text(
                          task['customerName'] ?? 'N/A',
                          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(task['taskType'] ?? 'Intervention'),
                        trailing: Chip(
                          label: Text(
                            DateFormat.jm().format(scheduledTime), // Format time e.g., "9:00 AM"
                          ),
                          backgroundColor: Colors.indigo.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          // TODO: Implement drill-down to task details page
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Center(child: Text("Could not load tasks.")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}