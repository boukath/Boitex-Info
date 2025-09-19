// lib/features/dashboard/presentation/widgets/activity_feed_widget.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/dashboard/data/activity_event.dart';
import 'package:boitex_info/shared_widgets/glass_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedWidget extends ConsumerWidget {
  const ActivityFeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(activityFeedProvider);

    return GlassContainer(
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.all(16.0),
      // --- FIXED: Gave the card a fixed height to resolve layout errors ---
      child: SizedBox(
        height: 300, // You can adjust this height
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Activity",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: feedAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const Center(child: Text("No recent activity."));
                  }
                  return ListView.separated(
                    itemCount: events.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      indent: 56,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _ActivityTile(event: event);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Center(child: Text("Couldn't load activity.")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityEvent event;
  const _ActivityTile({required this.event});

  InlineSpan _buildRichText(String text) {
    final parts = text.split(' ');
    return TextSpan(
      style: TextStyle(color: Colors.grey.shade700),
      children: parts.map((part) {
        final isHighlight = part.startsWith('#') || (parts.indexOf(part) < 2);
        return TextSpan(
          text: '$part ',
          style: TextStyle(
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
            color: isHighlight ? Colors.grey.shade900 : Colors.grey.shade700,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getIconColor(event.icon).withOpacity(0.1),
            ),
            child: Icon(event.icon, color: _getIconColor(event.icon)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: _buildRichText(event.text),
                ),
                const SizedBox(height: 4),
                Text(
                  timeago.format(event.timestamp.toDate()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(IconData icon) {
    if (icon == Icons.person_add_alt_1_outlined) return Colors.purple;
    if (icon == Icons.sync_alt_outlined) return Colors.blue;
    if (icon == Icons.task_alt_outlined) return Colors.green;
    return Colors.grey;
  }
}