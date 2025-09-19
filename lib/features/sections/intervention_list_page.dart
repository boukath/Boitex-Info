// lib/features/sections/intervention_list_page.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:boitex_info/features/sections/intervention_report_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Using the same status colors from the dashboard for consistency.
final statusColors = {
  InterventionStatus.New: Colors.grey.shade500,
  InterventionStatus.Assigned: Colors.purple.shade400,
  InterventionStatus.InProgress: Colors.blue.shade400,
  InterventionStatus.OnHold: Colors.amber.shade500,
  InterventionStatus.Resolved: Colors.green.shade500,
};

// Main page widget remains a ConsumerStatefulWidget to manage the animation controller.
class InterventionListPage extends ConsumerStatefulWidget {
  const InterventionListPage({super.key});

  @override
  ConsumerState<InterventionListPage> createState() => _InterventionListPageState();
}

class _InterventionListPageState extends ConsumerState<InterventionListPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openInterventionsAsync = ref.watch(openInterventionsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // A light background for better card contrast
      appBar: AppBar(
        title: const Text('Open Interventions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: openInterventionsAsync.when(
        data: (interventions) {
          if (interventions.isEmpty) {
            return const Center(child: Text('There are no open interventions.'));
          }
          // Using ListView.separated for clean dividers between cards
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: interventions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              // Passing the animation controller to our new custom card widget
              return _InterventionCard(
                intervention: interventions[index],
                animationController: _controller,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load interventions.')),
      ),
    );
  }
}

// A new, dedicated widget for the intervention card.
class _InterventionCard extends StatelessWidget {
  final Intervention intervention;
  final AnimationController animationController;

  const _InterventionCard({
    required this.intervention,
    required this.animationController,
  });

  // --- ADDED: Helper method to get the color for the flag icon ---
  Color _getFlagColor(String level) {
    return switch (level) {
      'High Urgent' => Colors.red.shade400,
      'Medium' => Colors.amber.shade700,
      _ => Colors.green.shade400, // Default for 'Normal'
    };
  }

  // --- ADDED: Helper method to format technician names ---
  String _getAssignedTechniciansText(List<String>? names) {
    if (names == null || names.isEmpty) {
      return 'Unassigned';
    }
    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Colors.grey.shade600;

    // --- MODIFIED: Highlight logic remains the same ---
    Color priorityColor = Colors.transparent;
    Color priorityHighlightColor = Colors.transparent;
    bool isHighlighted = false;

    switch (intervention.level) {
      case 'High Urgent':
        priorityColor = Colors.red.shade700;
        priorityHighlightColor = Colors.red.shade300;
        isHighlighted = true;
        break;
      case 'Medium':
        priorityColor = Colors.amber.shade700;
        priorityHighlightColor = Colors.amber.shade300;
        isHighlighted = true;
        break;
    }

    final colorTween = ColorTween(begin: priorityColor, end: priorityHighlightColor);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InterventionReportEditPage(intervention: intervention),
            ),
          );
        },
        child: Row(
          children: [
            if (isHighlighted)
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    // --- MODIFIED: Increased height to match new content ---
                    height: 140,
                    decoration: BoxDecoration(
                      color: colorTween.transform(animationController.value),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                // --- MODIFIED: The entire card layout is updated here ---
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- ADDED: Flag icon for priority ---
                        Icon(Icons.flag_rounded, color: _getFlagColor(intervention.level), size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            intervention.clientName,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A202C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      intervention.issue,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // --- ADDED: Store Location ---
                    Row(
                      children: [
                        Icon(Icons.store_mall_directory_outlined, size: 16, color: secondaryColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            intervention.storeLocation,
                            style: textTheme.bodySmall?.copyWith(color: secondaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // --- ADDED: Assigned Technicians ---
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 16, color: secondaryColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _getAssignedTechniciansText(intervention.assignedTechnicianNames),
                            style: textTheme.bodySmall?.copyWith(color: secondaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: secondaryColor),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat.yMMMd().format(intervention.date),
                              style: TextStyle(color: secondaryColor, fontSize: 12),
                            ),
                          ],
                        ),
                        Chip(
                          label: Text(intervention.status.name),
                          backgroundColor: (statusColors[intervention.status] ?? Colors.grey).withOpacity(0.15),
                          labelStyle: TextStyle(
                            color: statusColors[intervention.status] ?? Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}