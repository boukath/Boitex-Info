// lib/features/history/livraison_history_page.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/livraison_details_page.dart';
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LivraisonHistoryPage extends ConsumerStatefulWidget {
  const LivraisonHistoryPage({super.key});

  @override
  ConsumerState<LivraisonHistoryPage> createState() => _LivraisonHistoryPageState();
}

class _LivraisonHistoryPageState extends ConsumerState<LivraisonHistoryPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(livraisonHistorySearchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(livraisonHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Livraison History'),
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
                hintText: 'Search by client, location, code...',
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
              data: (groupedDeliveries) {
                if (groupedDeliveries.isEmpty) {
                  final query = ref.watch(livraisonHistorySearchQueryProvider);
                  return Center(child: Text(query.isEmpty ? 'No history found.' : 'No results found for "$query".'));
                }
                final groupKeys = groupedDeliveries.keys.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: groupKeys.length,
                  itemBuilder: (context, index) {
                    final key = groupKeys[index];
                    final deliveriesInGroup = groupedDeliveries[key]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.0, top: index == 0 ? 8.0 : 24.0),
                          child: Text(
                            key,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                          ),
                        ),
                        ...deliveriesInGroup.map((delivery) =>
                            _LivraisonHistoryCard(delivery: delivery)
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

class _LivraisonHistoryCard extends ConsumerWidget {
  final DeliveryNote delivery;
  const _LivraisonHistoryCard({required this.delivery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Colors.grey.shade600;
    final currentUser = ref.watch(boitexUserProvider).value;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if(currentUser != null) {
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
                    child: Text(delivery.client, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    label: const Text('Delivered'),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoRow(Icons.pin_drop_outlined, delivery.location, secondaryColor),
                  _buildInfoRow(Icons.calendar_month_outlined, DateFormat.yMMMd().format(delivery.deliveredAt?.toDate() ?? delivery.createdAt.toDate()), secondaryColor),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}