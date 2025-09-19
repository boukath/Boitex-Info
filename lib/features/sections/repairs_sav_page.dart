// lib/features/sections/repairs_sav_page.dart

import 'package:boitex_info/auth/models/boitex_user.dart';
// FIX: Removed the import for AppBackground as it was deleted.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'new_sav_ticket_page.dart';
import 'repairs_sav_domain.dart';
import 'repairs_sav_service.dart';
import 'sav_diagnosis_page.dart';
import 'sav_resolution_page.dart';
import 'sav_report_view_page.dart';

class RepairsSavPage extends StatefulWidget {
  final BoitexUser user;
  const RepairsSavPage({super.key, required this.user});

  @override
  State<RepairsSavPage> createState() => _RepairsSavPageState();
}

class _RepairsSavPageState extends State<RepairsSavPage> {
  final _service = SavService();
  SavStatus? _selectedStatus;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Replaced AppBackground with a standard Scaffold.
    return Scaffold(
      appBar: AppBar(title: const Text('Repairs & SAV')),
      body: SafeArea(
        child: Column(
          children: [
            _StatusFilterBar(
              selectedStatus: _selectedStatus,
              onStatusSelected: (status) => setState(() => _selectedStatus = status),
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
              child: StreamBuilder<List<SavTicket>>(
                stream: _service.getTicketsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                    return const _EmptyState(label: 'No SAV tickets found.');
                  }

                  final allItems = snapshot.data!;
                  final searchQuery = _searchController.text.toLowerCase();

                  final filteredItems = allItems.where((item) {
                    final statusMatch = _selectedStatus == null || item.status == _selectedStatus;
                    final searchMatch = searchQuery.isEmpty ||
                        item.client.toLowerCase().contains(searchQuery) ||
                        item.code.toLowerCase().contains(searchQuery);
                    return statusMatch && searchMatch;
                  }).toList();

                  if (filteredItems.isEmpty) {
                    return const _EmptyState(label: 'No tickets match your filters.');
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return _SavTicketCard(ticket: filteredItems[index]);
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
        label: const Text('New Ticket'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => NewSavTicketPage(currentUser: widget.user)),
        ),
      ),
    );
  }
}

// --- The rest of the classes (_StatusFilterBar, _SavTicketCard, _EmptyState) remain the same ---

class _StatusFilterBar extends StatelessWidget {
  final SavStatus? selectedStatus;
  final ValueChanged<SavStatus?> onStatusSelected;

  const _StatusFilterBar({this.selectedStatus, required this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    final statuses = [null, ...SavStatus.values];

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

class _SavTicketCard extends StatelessWidget {
  final SavTicket ticket;
  const _SavTicketCard({required this.ticket});

  (Color, IconData) _getStyleForStatus(SavStatus status) {
    return switch (status) {
      SavStatus.New => (Colors.blue, Icons.fiber_new_outlined),
      SavStatus.Assigned => (Colors.teal, Icons.person_pin_circle_outlined),
      SavStatus.Diagnosing => (Colors.orange, Icons.science_outlined),
      SavStatus.AwaitingParts => (Colors.purple, Icons.pause_circle_outline),
      SavStatus.RepairInProgress => (Colors.deepPurple, Icons.hourglass_top_outlined),
      SavStatus.Repaired => (Colors.green, Icons.check_circle_outline),
      SavStatus.ReturnedToClient => (Colors.grey.shade600, Icons.archive_outlined),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusIcon) = _getStyleForStatus(ticket.status);
    final assignedNames = ticket.assignedTechnicianNames;
    final assignedText = (assignedNames == null || assignedNames.isEmpty)
        ? 'Unassigned'
        : assignedNames.join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0), // Updated to match card's default radius
        onTap: () {
          if (ticket.status == SavStatus.New || ticket.status == SavStatus.Assigned) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SavDiagnosisPage(ticket: ticket),
            ));
          } else if (ticket.status == SavStatus.ReturnedToClient) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SavReportViewPage(ticket: ticket),
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SavResolutionPage(ticket: ticket),
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
                    child: Text(ticket.client, style: theme.textTheme.titleLarge),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(theme, statusColor, statusIcon),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${ticket.code} · ${DateFormat.yMMMd().format(ticket.date)}',
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
            ticket.status.name,
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