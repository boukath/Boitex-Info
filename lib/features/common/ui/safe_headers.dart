import 'package:flutter/material.dart';

/// Compact, responsive AppBar title with the Boitex logo (prevents overflow).
Widget buildSafeAppBarTitle(String title) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          'assets/images/boitex_logo.png',
          width: 28,
          height: 28,
          errorBuilder: (_, __, ___) => const Icon(Icons.blur_circular, size: 20),
        ),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}