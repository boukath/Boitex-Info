// lib/features/analytics/resolution_analytics.dart
import 'package:flutter/material.dart';

// A simple class to hold our calculated analytics results.
@immutable
class ResolutionAnalytics {
  final Duration average;
  final Duration fastest;
  final Duration slowest;
  final int resolvedCount;

  const ResolutionAnalytics({
    required this.average,
    required this.fastest,
    required this.slowest,
    required this.resolvedCount,
  });
}