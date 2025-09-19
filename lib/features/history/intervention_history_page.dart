// lib/features/history/intervention_history_page.dart
import 'package:boitex_info/core/services/pdf_service.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/history/intervention_report_view_page.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class InterventionHistoryPage extends ConsumerStatefulWidget {
  const InterventionHistoryPage({super.key});

  @override
  ConsumerState<InterventionHistoryPage> createState() => _InterventionHistoryPageState();
}

class _InterventionHistoryPageState extends ConsumerState<InterventionHistoryPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(interventionHistorySearchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(interventionHistoryProvider);

    // --- UI REDESIGN: New Scaffold and AppBar styling ---
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // A cleaner, softer background
      appBar: AppBar(
        title: const Text('Intervention History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by client, issue, code...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          Expanded(
            child: historyAsync.when(
              data: (groupedInterventions) {
                if (groupedInterventions.isEmpty) {
                  final query = ref.watch(interventionHistorySearchQueryProvider);
                  return Center(child: Text(query.isEmpty ? 'No history found.' : 'No results found for "$query".'));
                }
                final groupKeys = groupedInterventions.keys.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupKeys.length,
                  itemBuilder: (context, index) {
                    final key = groupKeys[index];
                    final interventionsInGroup = groupedInterventions[key]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- UI REDESIGN: Styled date group header ---
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 8.0 : 24.0),
                          child: Text(
                            key,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                          ),
                        ),
                        ...interventionsInGroup.map((intervention) =>
                            _InterventionHistoryCard(intervention: intervention)
                        ).toList(),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const Center(child: Text('Failed to load history.')),
            ),
          ),
        ],
      ),
    );
  }
}

// --- UI REDESIGN: The history card has been completely rebuilt ---
class _InterventionHistoryCard extends ConsumerStatefulWidget {
  final Intervention intervention;
  const _InterventionHistoryCard({required this.intervention});

  @override
  ConsumerState<_InterventionHistoryCard> createState() => _InterventionHistoryCardState();
}

class _InterventionHistoryCardState extends ConsumerState<_InterventionHistoryCard> {
  bool _isSharing = false;

  Future<void> _shareReport(BuildContext context) async {
    setState(() => _isSharing = true);
    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generateInterventionReport(widget.intervention);
      await Printing.sharePdf(bytes: pdfBytes, filename: 'report-${widget.intervention.code}.pdf');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to share PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  Future<void> _reopenTicket(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Re-open Ticket?'),
          content: const Text('This will change the status to "In Progress" and remove it from the history. Are you sure?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FilledButton( // Use a filled button for the confirmation action
              child: const Text('Confirm'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      try {
        await ref.read(dashboardRepositoryProvider).reopenIntervention(widget.intervention.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ticket ${widget.intervention.code} has been re-opened.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to re-open ticket: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Colors.grey.shade600;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InterventionReportViewPage(intervention: widget.intervention),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.intervention.clientName, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.intervention.issue, maxLines: 2, overflow: TextOverflow.ellipsis, style: textTheme.bodyMedium?.copyWith(color: secondaryColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_isSharing)
                    const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  else
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: secondaryColor),
                      onSelected: (value) {
                        if (value == 'share') _shareReport(context);
                        else if (value == 'reopen') _reopenTicket(context);
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'share',
                          child: ListTile(leading: Icon(Icons.share_outlined), title: Text('Share PDF')),
                        ),
                        const PopupMenuItem<String>(
                          value: 'reopen',
                          child: ListTile(leading: Icon(Icons.refresh), title: Text('Re-open Ticket')),
                        ),
                      ],
                    ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- ADDED: Store Location Display ---
                        _buildInfoRow(Icons.store_mall_directory_outlined, widget.intervention.storeLocation, secondaryColor),
                        const SizedBox(height: 6),
                        // --- ADDED: Date Display ---
                        _buildInfoRow(Icons.calendar_today_outlined, DateFormat.yMMMd().format(widget.intervention.date), secondaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // --- ADDED: "Better Box Status" Chip ---
                  Chip(
                    avatar: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    label: const Text('Resolved'),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for consistent info rows
  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}