// lib/features/dashboard/presentation/widgets/my_day_widget.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/core/roles.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:boitex_info/shared_widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusColors = {
  InterventionStatus.New: Colors.grey.shade500,
  InterventionStatus.Assigned: Colors.purple.shade400,
  InterventionStatus.InProgress: Colors.blue.shade400,
  InterventionStatus.OnHold: Colors.amber.shade500,
  InterventionStatus.Resolved: Colors.green.shade500,
};

class MyDayWidget extends ConsumerWidget {
  const MyDayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(boitexUserProvider);

    return GlassContainer(
      padding: const EdgeInsets.all(16.0),
      borderRadius: BorderRadius.circular(12),
      // --- FIXED: Gave the card a fixed height to resolve layout errors ---
      child: SizedBox(
        height: 150,
        child: asyncUser.when(
          data: (user) {
            final userRole = user?.role ?? UserRole.technician;
            final tasksAsync = userRole == UserRole.manager
                ? ref.watch(managerTasksProvider)
                : ref.watch(technicianTasksProvider);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userRole == UserRole.manager ? "Awaiting Assignment" : "Today's Tasks",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: tasksAsync.when(
                    data: (tasks) {
                      if (tasks.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                userRole == UserRole.manager ? Icons.playlist_add_check_circle_outlined : Icons.celebration_outlined,
                                size: 40,
                                color: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                userRole == UserRole.manager
                                    ? "No new interventions to assign."
                                    : "All caught up! 🎉",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return _TaskTile(task: task);
                        },
                        separatorBuilder: (context, index) => const Divider(height: 1),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const Center(child: Text("Couldn't load tasks.")),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const Center(child: Text("Couldn't load user info.")),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final Intervention task;
  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final color = statusColors[task.status] ?? Colors.grey;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.clientName,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade900),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task.issue,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Chip(
              label: Text(task.status.name),
              backgroundColor: color.withOpacity(0.15),
              labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              side: BorderSide.none,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}