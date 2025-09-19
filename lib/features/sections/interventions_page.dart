// lib/features/sections/interventions_page.dart

import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/common/ui/app_background.dart';
import 'package:boitex_info/core/roles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'intervention_domain.dart';
import 'intervention_pdf_helper.dart';
import 'intervention_report_view_page.dart';
import 'intervention_request_page.dart';
import 'intervention_service.dart';
import 'technician_report_page.dart';

class InterventionsPage extends StatefulWidget {
  final BoitexUser currentUser;
  const InterventionsPage({super.key, required this.currentUser});

  @override
  State<InterventionsPage> createState() => _InterventionsPageState();
}

class _InterventionsPageState extends State<InterventionsPage> {
  final _service = InterventionService();
  InterventionStatus? _selectedStatus;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Interventions')),
        body: SafeArea(
          child: Column(
            children: [
              _StatusFilterBar(
                selectedStatus: _selectedStatus,
                onStatusSelected: (status) {
                  setState(() {
                    _selectedStatus = status;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search by client or code...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Intervention>>(
                  stream: _service.getInterventionsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const _EmptyState(label: 'No interventions found.');
                    }

                    final allItems = snapshot.data!;
                    final searchQuery = _searchController.text.toLowerCase();

                    final filteredItems = allItems.where((item) {
                      final statusMatch = _selectedStatus == null || item.status == _selectedStatus;
                      final searchMatch = searchQuery.isEmpty ||
                          item.clientName.toLowerCase().contains(searchQuery) ||
                          item.code.toLowerCase().contains(searchQuery);
                      return statusMatch && searchMatch;
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return const _EmptyState(label: 'No interventions match your filters.');
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _InterventionCard(
                          intervention: filteredItems[index],
                          currentUser: widget.currentUser,
                          service: _service,
                          onError: _showErrorSnackBar,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text('New Request'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => InterventionRequestPage(currentUser: widget.currentUser)),
          ),
        ),
      ),
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  final InterventionStatus? selectedStatus;
  final ValueChanged<InterventionStatus?> onStatusSelected;

  const _StatusFilterBar({this.selectedStatus, required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    final statuses = [null, ...InterventionStatus.values];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = selectedStatus == status;
          return ChoiceChip(
            label: Text(status?.name ?? 'All'),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onStatusSelected(status);
              }
            },
          );
        },
      ),
    );
  }
}

class _InterventionCard extends StatelessWidget {
  final Intervention intervention;
  final BoitexUser currentUser;
  final InterventionService service;
  final void Function(String) onError;

  const _InterventionCard({
    required this.intervention,
    required this.currentUser,
    required this.service,
    required this.onError,
  });

  (Color, IconData) _getStyleForStatus(InterventionStatus status) {
    return switch (status) {
      InterventionStatus.New => (Colors.blue, Icons.fiber_new_outlined),
      InterventionStatus.Assigned => (Colors.teal, Icons.person_pin_circle_outlined),
      InterventionStatus.InProgress => (Colors.purple, Icons.hourglass_top_outlined),
      InterventionStatus.OnHold => (Colors.orange, Icons.pause_circle_outline),
      InterventionStatus.Resolved => (Colors.green, Icons.check_circle_outline),
    };
  }

  Color _getLevelColor(String level) {
    return switch(level) {
      'Red' => Colors.redAccent,
      'Yellow' => Colors.orangeAccent,
      _ => Colors.green,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusIcon) = _getStyleForStatus(intervention.status);
    final assignedNames = intervention.assignedTechnicianNames;
    final assignedText = (assignedNames == null || assignedNames.isEmpty)
        ? 'Unassigned'
        : assignedNames.join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          if (intervention.status == InterventionStatus.Resolved) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => InterventionReportViewPage(intervention: intervention),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => TechnicianReportPage(intervention: intervention),
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      intervention.clientName,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(theme, statusColor, statusIcon),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${intervention.code} · ${DateFormat.yMMMd().format(intervention.date)}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const Divider(height: 24),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Assigned to: $assignedText',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.priority_high_rounded, size: 16, color: _getLevelColor(intervention.level)),
                  const SizedBox(width: 4),
                  Text(intervention.level, style: theme.textTheme.bodyMedium),
                ],
              ),
              if (currentUser.role.canChangeInterventionStatus) ...[
                const Divider(height: 20),
                _buildManagerActions(context),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagerActions(BuildContext context) {
    const List<InterventionStatus> managerActions = [
      InterventionStatus.InProgress,
      InterventionStatus.OnHold,
      InterventionStatus.Resolved,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<InterventionStatus>(
              isExpanded: true,
              hint: const Text('Change Status...'),
              value: null,
              items: managerActions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.name),
                );
              }).toList(),
              onChanged: (newStatus) async {
                if (newStatus != null) {
                  try {
                    final updated = intervention.copyWith(status: newStatus);
                    await service.updateIntervention(updated);
                  } catch (e) {
                    onError('Failed to update status: $e');
                  }
                }
              },
            ),
          ),
        ),
        if (intervention.hasReport) ...[
          const SizedBox(width: 16),
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              try {
                final bytes = await InterventionPdfHelper.generateSingleReportPdf(intervention);
                await Printing.layoutPdf(onLayout: (_) async => bytes);
              } catch (e) {
                onError('Could not generate PDF: $e');
              }
            },
          ),
          IconButton(
            tooltip: 'Share Report',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              try {
                final bytes = await InterventionPdfHelper.generateSingleReportPdf(intervention);
                await Printing.sharePdf(bytes: bytes, filename: 'Intervention_${intervention.code}.pdf');
              } catch (e) {
                onError('Could not share PDF: $e');
              }
            },
          ),
        ]
      ],
    );
  }

  Widget _buildStatusChip(ThemeData theme, Color statusColor, IconData statusIcon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 14),
          const SizedBox(width: 4),
          Text(
            intervention.status.name,
            style: theme.textTheme.labelMedium?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String label;
  const _EmptyState({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.inbox_outlined, size: 60, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
        const SizedBox(height: 16),
        Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
        )),
      ]),
    );
  }
}