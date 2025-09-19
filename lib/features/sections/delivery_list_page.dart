// lib/features/sections/delivery_list_page.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/livraison_details_page.dart';
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DeliveryListPage extends ConsumerWidget {
  const DeliveryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- FIXED: Watch the new activeDeliveriesProvider instead of the old one ---
    final deliveriesAsync = ref.watch(activeDeliveriesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Active Deliveries'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: deliveriesAsync.when(
        data: (deliveries) {
          if (deliveries.isEmpty) {
            return const Center(child: Text('There are no active deliveries.'));
          }
          // Sort the list to show 'inTransit' items first
          deliveries.sort((a, b) {
            if (a.status == DeliveryStatus.inTransit && b.status == DeliveryStatus.pending) {
              return -1; // a comes first
            }
            if (a.status == DeliveryStatus.pending && b.status == DeliveryStatus.inTransit) {
              return 1; // b comes first
            }
            return 0; // Keep original order for same statuses
          });
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              return _DeliveryListCard(delivery: deliveries[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Failed to load deliveries.')),
      ),
    );
  }
}

class _DeliveryListCard extends ConsumerWidget {
  final DeliveryNote delivery;
  const _DeliveryListCard({required this.delivery});

  Color _getStatusColor(DeliveryStatus status) {
    return switch (status) {
      DeliveryStatus.pending => Colors.orange.shade400,
      DeliveryStatus.inTransit => Colors.blue.shade400,
      DeliveryStatus.delivered => Colors.green.shade500,
      DeliveryStatus.cancelled => Colors.red.shade400,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Colors.grey.shade600;
    final currentUser = ref.watch(boitexUserProvider).value;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LivraisonDetailsPage(note: delivery, currentUser: currentUser),
              ),
            );
          }
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
                    child: Text(
                      delivery.client,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(statusToString(delivery.status)),
                    backgroundColor: _getStatusColor(delivery.status).withOpacity(0.15),
                    labelStyle: TextStyle(color: _getStatusColor(delivery.status), fontWeight: FontWeight.bold),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: secondaryColor),
                  const SizedBox(width: 6),
                  Text(DateFormat.yMMMd().format(delivery.createdAt.toDate()), style: TextStyle(color: secondaryColor, fontSize: 12)),
                  const SizedBox(width: 12),
                  const Text('•', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 12),
                  Icon(Icons.location_on, size: 14, color: secondaryColor),
                  const SizedBox(width: 6),
                  Expanded(child: Text(delivery.location, overflow: TextOverflow.ellipsis, style: TextStyle(color: secondaryColor, fontSize: 12))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}