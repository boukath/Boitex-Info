// lib/features/sections/installations_page.dart

import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/common/ui/app_background.dart';
import 'package:boitex_info/core/roles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'installation_completion_page.dart';
import 'installation_domain.dart';
import 'installation_report_view_page.dart';
import 'installation_request_page.dart';
import 'installation_service.dart';

class InstallationsPage extends StatefulWidget {
  final BoitexUser user;
  const InstallationsPage({super.key, required this.user});

  @override
  State<InstallationsPage> createState() => _InstallationsPageState();
}

class _InstallationsPageState extends State<InstallationsPage> {
  final _service = InstallationService();
  InstallationStatus? _selectedStatus;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Installations')),
        body: SafeArea(
          child: Column(
            children: [
              _StatusFilterBar(
                selectedStatus: _selectedStatus,
                onStatusSelected: (status) {
                  setState(() => _selectedStatus = status);
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
                child: StreamBuilder<List<Installation>>(
                  stream: _service.getInstallationsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const _EmptyState(label: 'No installations found.');
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
                      return const _EmptyState(label: 'No installations match your filters.');
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return _InstallationCard(
                          installation: filteredItems[index],
                          currentUser: widget.user,
                          service: _service,
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
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => InstallationRequestPage(currentUser: widget.user),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  final InstallationStatus? selectedStatus;
  final ValueChanged<InstallationStatus?> onStatusSelected;

  const _StatusFilterBar({this.selectedStatus, required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    final statuses = [null, ...InstallationStatus.values];

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

class _InstallationCard extends StatelessWidget {
  final Installation installation;
  final BoitexUser currentUser;
  final InstallationService service;

  const _InstallationCard({
    required this.installation,
    required this.currentUser,
    required this.service,
  });

  (Color, IconData) _getStyleForStatus(InstallationStatus status) {
    return switch (status) {
      InstallationStatus.New => (Colors.blue, Icons.fiber_new_outlined),
      InstallationStatus.Assigned => (Colors.teal, Icons.person_pin_circle_outlined),
      InstallationStatus.InProgress => (Colors.purple, Icons.hourglass_top_outlined),
      InstallationStatus.OnHold => (Colors.orange, Icons.pause_circle_outline),
      InstallationStatus.Completed => (Colors.green, Icons.check_circle_outline),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusIcon) = _getStyleForStatus(installation.status);

    final assignedNames = installation.assignedTechnicianNames;
    final assignedText = (assignedNames == null || assignedNames.isEmpty)
        ? 'Unassigned'
        : assignedNames.join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          if (installation.status == InstallationStatus.Completed) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => InstallationReportViewPage(installation: installation),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => InstallationCompletionPage(installation: installation),
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
                    child: Text(installation.clientName, style: theme.textTheme.titleLarge),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(theme, statusColor, statusIcon),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${installation.code} · ${DateFormat.yMMMd().format(installation.date)}',
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
                ],
              ),
            ],
          ),
        ),
      ),
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
            installation.status.name,
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