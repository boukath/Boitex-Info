// lib/shared_widgets/section_list_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'section_list_item.dart';

class SectionListCard extends StatelessWidget {
  final SectionListItem item;

  const SectionListCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final secondaryColor = Colors.grey.shade600;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display priority icon if it exists
                  if (item.priorityIcon != null) ...[
                    Icon(item.priorityIcon, color: item.priorityIconColor, size: 24),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      item.title,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status Chip
                  Chip(
                    label: Text(item.statusText),
                    backgroundColor: item.statusColor.withOpacity(0.15),
                    labelStyle: TextStyle(
                      color: item.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Subtitle
              Padding(
                padding: EdgeInsets.only(left: item.priorityIcon != null ? 36 : 0),
                child: Text(
                  item.subtitle,
                  style: textTheme.bodyMedium?.copyWith(color: secondaryColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(height: 24),
              // Date
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: secondaryColor),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat.yMMMd().format(item.date),
                    style: TextStyle(color: secondaryColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}