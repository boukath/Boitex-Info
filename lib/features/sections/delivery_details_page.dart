// lib/features/sections/delivery_details_page.dart
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final DeliveryNote delivery;
  const DeliveryDetailsPage({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Details for ${delivery.code}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(delivery.client, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.location_on_outlined, 'Location', delivery.location),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.phone_outlined, 'Phone', delivery.phone),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Line Items Section
            _buildSectionTitle('Articles', theme),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Column(
                children: [
                  // Table Header
                  ListTile(
                    dense: true,
                    tileColor: Colors.grey.shade200,
                    title: Row(
                      children: [
                        const Expanded(flex: 3, child: Text('Article', style: TextStyle(fontWeight: FontWeight.bold))),
                        const Expanded(flex: 1, child: Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                        if (delivery.lines.any((l) => l.price != null))
                          const Expanded(flex: 2, child: Text('Price', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  // Table Rows
                  ...delivery.lines.map((line) {
                    return ListTile(
                      title: Row(
                        children: [
                          Expanded(flex: 3, child: Text(line.article)),
                          Expanded(flex: 1, child: Text(line.qty.toString(), textAlign: TextAlign.center)),
                          if (delivery.lines.any((l) => l.price != null))
                            Expanded(flex: 2, child: Text(line.price?.toStringAsFixed(2) ?? '-', textAlign: TextAlign.right)),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status and Date Section
            _buildSectionTitle('Status & Info', theme),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow(statusToIcon(delivery.status), 'Status', statusToString(delivery.status),
                        highlightColor: Colors.blue.shade700),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.calendar_today_outlined, 'Created Date',
                        DateFormat.yMMMd().format(delivery.createdAt.toDate())),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.person_outline, 'Created By', delivery.createdByName),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('Mark as In Transit'),
                    onPressed: delivery.status == DeliveryStatus.pending ? () {
                      // TODO: Implement logic to update status
                    } : null, // Disable if not pending
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.task_alt_outlined),
                    label: const Text('Mark as Delivered'),
                    onPressed: delivery.status == DeliveryStatus.inTransit ? () {
                      // TODO: Implement logic to update status
                    } : null, // Disable if not in transit
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey.shade600)),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? highlightColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade500),
        const SizedBox(width: 16),
        Text('$label: ', style: TextStyle(color: Colors.grey.shade700)),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, color: highlightColor ?? Colors.black),
          ),
        ),
      ],
    );
  }
}