// lib/features/dashboard/application/dashboard_providers.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/core/api/firestore_service.dart';
import 'package:boitex_info/features/analytics/resolution_analytics.dart';
import 'package:boitex_info/features/dashboard/data/activity_event.dart';
import 'package:boitex_info/features/dashboard/data/dashboard_repository.dart';
import 'package:boitex_info/features/sections/installation_domain.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:boitex_info/features/sections/repairs_sav_domain.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ADD this import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// --- Authentication & Service Providers ---
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// ADDED: A direct provider for the FirebaseFirestore instance
final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

final boitexUserProvider = StreamProvider<BoitexUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.value != null) {
    final uid = authState.value!.uid;
    return ref.watch(firestoreServiceProvider).userStream(uid: uid);
  }
  return Stream.value(null);
});

final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(boitexUserProvider).when(
    data: (user) => user?.uid ?? '',
    loading: () => '',
    error: (_, __) => '',
  );
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});


// --- Dashboard KPI & List Providers (Not filtered by date) ---
final openTicketsCountProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardRepositoryProvider).getOpenTicketsCount();
});

final pendingDeliveriesCountProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardRepositoryProvider).getPendingDeliveriesCount();
});

final repairBacklogCountProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardRepositoryProvider).getRepairBacklogCount();
});

final activeInstallationsProvider = StreamProvider<List<Installation>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getActiveInstallations();
});

final activeInstallationsCountProvider = Provider<AsyncValue<int>>((ref) {
  final asyncInstallationsList = ref.watch(activeInstallationsProvider);
  return asyncInstallationsList.whenData((list) => list.length);
});

final pendingDeliveriesProvider = StreamProvider<List<DeliveryNote>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getPendingDeliveries();
});

final activeDeliveriesProvider = StreamProvider.autoDispose<List<DeliveryNote>>((ref) {
  // FIXED: Watch the new 'firestoreProvider' instead of your custom service.
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('livraisons')
      .where('status', whereIn: [
    DeliveryStatus.pending.name,
    DeliveryStatus.inTransit.name,
  ])
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => DeliveryNote.fromJson(doc.data()!, doc.id)).toList());
});

final openInterventionsProvider = StreamProvider<List<Intervention>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getOpenInterventions();
});

final technicianTasksProvider = StreamProvider<List<Intervention>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId.isEmpty) return Stream.value([]);
  return ref.watch(dashboardRepositoryProvider).getTechnicianTasks(userId);
});

final managerTasksProvider = StreamProvider<List<Intervention>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getManagerTasks();
});

final activityFeedProvider = StreamProvider<List<ActivityEvent>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getActivityFeed();
});


// --- Analytics Providers ---
final analyticsDateRangeProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  return DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now);
});

// Intervention Analytics
final interventionStatusDistributionProvider =
StreamProvider.family<Map<String, int>, DateTimeRange>((ref, dateRange) {
  return ref.watch(dashboardRepositoryProvider).getInterventionStatusDistribution(dateRange);
});

final interventionPriorityProvider =
StreamProvider.family<Map<String, int>, DateTimeRange>((ref, dateRange) {
  return ref.watch(dashboardRepositoryProvider).getInterventionPriorityDistribution(dateRange);
});

final resolvedInterventionsProvider =
StreamProvider.family<List<Intervention>, DateTimeRange>((ref, dateRange) {
  return ref.watch(dashboardRepositoryProvider).getResolvedInterventionsStream(dateRange);
});

final resolutionTimeAnalyticsProvider =
Provider.family<AsyncValue<ResolutionAnalytics>, DateTimeRange>((ref, dateRange) {
  final asyncInterventions = ref.watch(resolvedInterventionsProvider(dateRange));
  return asyncInterventions.whenData((interventions) {
    try {
      if (interventions.isEmpty) {
        return const ResolutionAnalytics(
          average: Duration.zero,
          fastest: Duration.zero,
          slowest: Duration.zero,
          resolvedCount: 0,
        );
      }
      List<Duration> durations = [];
      for (var i in interventions) {
        if (i.reportDate != null) {
          durations.add(i.reportDate!.difference(i.date));
        }
      }
      if (durations.isEmpty) {
        return ResolutionAnalytics(
            average: Duration.zero,
            fastest: Duration.zero,
            slowest: Duration.zero,
            resolvedCount: interventions.length);
      }
      final total = durations.reduce((a, b) => a + b);
      final avg = total.inMicroseconds ~/ durations.length;
      durations.sort();
      return ResolutionAnalytics(
        average: Duration(microseconds: avg),
        fastest: durations.first,
        slowest: durations.last,
        resolvedCount: interventions.length,
      );
    } catch (e) {
      print("Error calculating resolution analytics: $e");
      throw Exception('Failed to process intervention data.');
    }
  });
});

final technicianLeaderboardProvider =
Provider.family<AsyncValue<List<MapEntry<String, int>>>, DateTimeRange>((ref, dateRange) {
  final asyncInterventions = ref.watch(resolvedInterventionsProvider(dateRange));
  return asyncInterventions.whenData((interventions) {
    try {
      if (interventions.isEmpty) return [];
      final counts = <String, int>{};
      for (var i in interventions) {
        final names = i.assignedTechnicianNames;
        if (names != null && names.isNotEmpty) {
          for (var name in names) {
            if (name.isNotEmpty) counts[name] = (counts[name] ?? 0) + 1;
          }
        }
      }
      return counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    } catch (e) {
      print("Error calculating leaderboard: $e");
      throw Exception('Failed to process technician data.');
    }
  });
});

final allInterventionsProvider = StreamProvider.family<List<Intervention>, DateTimeRange>((ref, dateRange) {
  return ref.watch(dashboardRepositoryProvider).getAllInterventionsStream(dateRange);
});

final commonIssuesProvider =
Provider.family<AsyncValue<List<MapEntry<String, int>>>, DateTimeRange>((ref, dateRange) {
  final asyncInterventions = ref.watch(allInterventionsProvider(dateRange));
  return asyncInterventions.whenData((interventions) {
    if (interventions.isEmpty) return [];
    final counts = <String, int>{};
    for (var i in interventions) {
      final issue = i.issue.trim();
      if (issue.isNotEmpty) counts[issue] = (counts[issue] ?? 0) + 1;
    }
    return (counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).take(5).toList();
  });
});


// Installation Analytics
final totalInstallationsProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardRepositoryProvider).getTotalInstallationsCount();
});

final completedInstallationsProvider = StreamProvider<int>((ref) {
  return ref.watch(dashboardRepositoryProvider).getCompletedInstallationsCount();
});

final installationSuccessRateProvider = Provider<AsyncValue<double>>((ref) {
  final totalAsync = ref.watch(totalInstallationsProvider);
  final completedAsync = ref.watch(completedInstallationsProvider);

  if (totalAsync is AsyncData && completedAsync is AsyncData) {
    final total = totalAsync.value ?? 0;
    final completed = completedAsync.value ?? 0;
    if (total == 0) {
      return const AsyncData(0.0);
    }
    return AsyncData((completed / total) * 100);
  }
  if (totalAsync is AsyncError || completedAsync is AsyncError) {
    return const AsyncError('Failed to load installation data', StackTrace.empty);
  }
  return const AsyncLoading();
});

final installationStatusProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getInstallationStatusDistribution();
});

final monthlyInstallationsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getMonthlyInstallations();
});

final installationTypesProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getInstallationTypesDistribution();
});

// SAV Analytics
final savBacklogTrendProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getSavBacklogTrend();
});

final savStatusProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getSavStatusDistribution();
});

final savCommonFaultsProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getSavCommonFaults();
});

// Livraison Analytics
final deliveryStatusProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getDeliveryStatusDistribution();
});

final monthlyDeliveriesProvider = StreamProvider<Map<String, int>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getMonthlyDeliveries();
});

// --- History Providers ---

final interventionHistorySearchQueryProvider = StateProvider<String>((ref) => '');

final _interventionHistoryBaseProvider = StreamProvider<List<Intervention>>((ref) {
  return ref.watch(dashboardRepositoryProvider).getInterventionHistory();
});

final interventionHistoryProvider = Provider<AsyncValue<Map<String, List<Intervention>>>>((ref) {
  final searchQuery = ref.watch(interventionHistorySearchQueryProvider).toLowerCase();
  final historyAsync = ref.watch(_interventionHistoryBaseProvider);

  return historyAsync.whenData((interventions) {
    final filteredList = searchQuery.isEmpty
        ? interventions
        : interventions.where((i) {
      return i.clientName.toLowerCase().contains(searchQuery) ||
          i.issue.toLowerCase().contains(searchQuery) ||
          i.code.toLowerCase().contains(searchQuery);
    }).toList();

    final Map<String, List<Intervention>> grouped = {};
    for (var intervention in filteredList) {
      final date = intervention.reportDate ?? intervention.date;
      final groupKey = _getGroupKey(date);
      if (grouped[groupKey] == null) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(intervention);
    }
    return grouped;
  });
});

String _getGroupKey(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final reportDay = DateTime(date.year, date.month, date.day);

  if (reportDay == today) return 'Today';
  if (reportDay == yesterday) return 'Yesterday';
  if (now.difference(reportDay).inDays < 7) return 'This Week';

  return DateFormat('MMMM yyyy').format(date);
}

// --- ADD these providers for Livraison History ---

final livraisonHistorySearchQueryProvider = StateProvider<String>((ref) => '');

final _livraisonHistoryBaseProvider = StreamProvider<List<DeliveryNote>>((ref) {
  // This fetches all documents where the status is 'delivered'
  return ref.watch(dashboardRepositoryProvider).getDeliveryHistory();
});

final livraisonHistoryProvider = Provider<AsyncValue<Map<String, List<DeliveryNote>>>>((ref) {
  final searchQuery = ref.watch(livraisonHistorySearchQueryProvider).toLowerCase();
  final historyAsync = ref.watch(_livraisonHistoryBaseProvider);

  return historyAsync.whenData((deliveries) {
    // Filter the list based on the search query
    final filteredList = searchQuery.isEmpty
        ? deliveries
        : deliveries.where((d) {
      return d.client.toLowerCase().contains(searchQuery) ||
          d.location.toLowerCase().contains(searchQuery) ||
          d.code.toLowerCase().contains(searchQuery);
    }).toList();

    // Group the filtered list by date
    final Map<String, List<DeliveryNote>> grouped = {};
    for (var delivery in filteredList) {
      final date = delivery.deliveredAt?.toDate() ?? delivery.createdAt.toDate();
      final groupKey = _getGroupKey(date);
      if (grouped[groupKey] == null) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(delivery);
    }
    return grouped;
  });
});