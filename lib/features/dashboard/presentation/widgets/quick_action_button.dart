// lib/features/dashboard/presentation/widgets/quick_action_button.dart
import 'package:boitex_info/shared_widgets/glass_container.dart';
import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  // --- FIXED: Changed onTap to be nullable by adding a '?' ---
  final VoidCallback? onTap;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The content color will be dimmed if onTap is null (i.e., disabled)
    final Color contentColor = onTap != null ? Colors.grey.shade800 : Colors.grey.shade400;

    return SizedBox(
      width: 80,
      child: GestureDetector(
        onTap: onTap, // This now correctly accepts null to disable gestures
        child: GlassContainer(
          height: 90,
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: contentColor, size: 30),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}