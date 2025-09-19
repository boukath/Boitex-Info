import 'package:flutter/material.dart';

Color levelColor(String level) => switch (level) {
  'Green' => const Color(0xFF00E676),
  'Yellow' => const Color(0xFFFFD54F),
  'Red' => const Color(0xFFE53935),
  _ => Colors.grey,
};