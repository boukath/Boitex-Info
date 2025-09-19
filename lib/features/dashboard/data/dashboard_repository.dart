// lib/features/dashboard/data/dashboard_repository.dart
import 'package:boitex_info/features/dashboard/data/activity_event.dart';
import 'package:boitex_info/features/sections/installation_domain.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:boitex_info/features/sections/repairs_sav_domain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addActivityEvent(String text, String iconName) {
    return _firestore.collection('activity_feed').add({
      'text': text,
      'icon': iconName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // --- KPI & List Methods ---

  Stream<int> getOpenTicketsCount() {
    return _firestore.collection('interventions').where('status', whereIn: [
      InterventionStatus.New.name,
      InterventionStatus.Assigned.name,
      InterventionStatus.InProgress.name,
      InterventionStatus.OnHold.name,
    ]).snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getPendingDeliveriesCount() {
    return _firestore
        .collection('livraisons')
        .where('status', isEqualTo: DeliveryStatus.pending.name)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<List<DeliveryNote>> getPendingDeliveries() {
    return _firestore
        .collection('livraisons')
        .where('status', isEqualTo: DeliveryStatus.pending.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DeliveryNote.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<int> getRepairBacklogCount() {
    return _firestore
        .collection('sav_tickets')
        .where('status', isNotEqualTo: SavStatus.ReturnedToClient.name)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<List<Intervention>> getOpenInterventions() {
    return _firestore.collection('interventions').where('status', whereIn: [
      InterventionStatus.New.name,
      InterventionStatus.Assigned.name,
      InterventionStatus.InProgress.name,
      InterventionStatus.OnHold.name,
    ]).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Intervention.fromJson(doc.data(), doc.id)).toList());
  }

  Stream<List<Installation>> getActiveInstallations() {
    return _firestore
        .collection('installations')
        .where('status', isNotEqualTo: InstallationStatus.Completed.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Installation.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<List<Intervention>> getTechnicianTasks(String technicianId) {
    return _firestore
        .collection('interventions')
        .where('assignedTechnicianIds', arrayContains: technicianId)
        .where('status', isNotEqualTo: InterventionStatus.Resolved.name)
        .orderBy('status')
        .limit(5)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Intervention.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<List<Intervention>> getManagerTasks() {
    return _firestore
        .collection('interventions')
        .where('status', isEqualTo: InterventionStatus.New.name)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Intervention.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<List<ActivityEvent>> getActivityFeed() {
    return _firestore
        .collection('activity_feed')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ActivityEvent.fromJson(doc.data()))
        .toList());
  }

  // --- Analytics Methods ---

  Stream<Map<String, int>> getInterventionStatusDistribution(DateTimeRange dateRange) {
    return _firestore
        .collection('interventions')
        .where('date', isGreaterThanOrEqualTo: dateRange.start)
        .where('date', isLessThanOrEqualTo: dateRange.end)
        .snapshots()
        .map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final status = doc.data()['status'] as String? ?? 'New';
        counts[status] = (counts[status] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<Map<String, int>> getInterventionPriorityDistribution(DateTimeRange dateRange) {
    return _firestore
        .collection('interventions')
        .where('date', isGreaterThanOrEqualTo: dateRange.start)
        .where('date', isLessThanOrEqualTo: dateRange.end)
        .snapshots()
        .map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final level = doc.data()['level'] as String? ?? 'Green';
        counts[level] = (counts[level] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<List<Intervention>> getResolvedInterventionsStream(DateTimeRange dateRange) {
    return _firestore
        .collection('interventions')
        .where('status', isEqualTo: InterventionStatus.Resolved.name)
        .where('date', isGreaterThanOrEqualTo: dateRange.start)
        .where('date', isLessThanOrEqualTo: dateRange.end)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Intervention.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<List<Intervention>> getAllInterventionsStream(DateTimeRange dateRange) {
    return _firestore
        .collection('interventions')
        .where('date', isGreaterThanOrEqualTo: dateRange.start)
        .where('date', isLessThanOrEqualTo: dateRange.end)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Intervention.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<int> getTotalInstallationsCount() {
    return _firestore.collection('installations').snapshots().map((snapshot) => snapshot.size);
  }

  Stream<int> getCompletedInstallationsCount() {
    return _firestore
        .collection('installations')
        .where('status', isEqualTo: InstallationStatus.Completed.name)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<Map<String, int>> getInstallationStatusDistribution() {
    return _firestore.collection('installations').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final status = doc.data()['status'] as String? ?? 'New';
        counts[status] = (counts[status] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<Map<String, int>> getMonthlyInstallations() {
    return _firestore.collection('installations').snapshots().map((snapshot) {
      final Map<String, int> counts = {};
      final now = DateTime.now();

      for (int i = 11; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final key = DateFormat('MMM yyyy').format(month);
        counts[key] = 0;
      }

      for (var doc in snapshot.docs) {
        final date = (doc.data()['date'] as Timestamp?)?.toDate();
        if (date != null) {
          final key = DateFormat('MMM yyyy').format(date);
          if (counts.containsKey(key)) {
            counts[key] = (counts[key] ?? 0) + 1;
          }
        }
      }
      return counts;
    });
  }

  Stream<Map<String, int>> getInstallationTypesDistribution() {
    return _firestore.collection('installations').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final type = doc.data()['modelType'] as String? ?? 'Unknown';
        if (type.isNotEmpty) {
          counts[type] = (counts[type] ?? 0) + 1;
        }
      }
      return counts;
    });
  }

  Stream<Map<String, int>> getSavBacklogTrend() {
    return _firestore
        .collection('sav_tickets')
        .where('status', isNotEqualTo: SavStatus.ReturnedToClient.name)
        .snapshots()
        .map((snapshot) {
      final Map<String, int> weeklyCounts = {};
      for (var doc in snapshot.docs) {
        final date = (doc.data()['date'] as Timestamp?)?.toDate();
        if (date != null) {
          final weekOfYear = (date.difference(DateTime(date.year, 1, 1)).inDays / 7).ceil();
          final key = 'Week $weekOfYear';
          weeklyCounts[key] = (weeklyCounts[key] ?? 0) + 1;
        }
      }
      return weeklyCounts;
    });
  }

  Stream<Map<String, int>> getSavStatusDistribution() {
    return _firestore
        .collection('sav_tickets')
        .where('status', isNotEqualTo: SavStatus.ReturnedToClient.name)
        .snapshots()
        .map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final status = doc.data()['status'] as String? ?? 'New';
        counts[status] = (counts[status] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<Map<String, int>> getSavCommonFaults() {
    return _firestore
        .collection('sav_tickets')
        .snapshots()
        .map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final fault = doc.data()['diagnostic'] as String? ?? 'Unknown';
        if (fault.isNotEmpty && fault != 'Unknown') {
          counts[fault] = (counts[fault] ?? 0) + 1;
        }
      }
      return counts;
    });
  }

  Stream<Map<String, int>> getDeliveryStatusDistribution() {
    return _firestore.collection('livraisons').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final status = doc.data()['status'] as String? ?? 'pending';
        counts[status] = (counts[status] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<List<Intervention>> getInterventionHistory() {
    return _firestore
        .collection('interventions')
        .where('status', isEqualTo: InterventionStatus.Resolved.name)
        .orderBy('reportDate', descending: true) // Show newest first
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Intervention.fromJson(doc.data(), doc.id))
        .toList());
  }

  // --- ADDED: The missing method for delivery history ---
  Stream<List<DeliveryNote>> getDeliveryHistory() {
    return _firestore
        .collection('livraisons')
        .where('status', isEqualTo: DeliveryStatus.delivered.name)
        .orderBy('deliveredAt', descending: true)
        .limit(50) // Get the 50 most recent
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DeliveryNote.fromJson(doc.data(), doc.id))
        .toList());
  }

  Stream<Map<String, int>> getMonthlyDeliveries() {
    return _firestore.collection('livraisons').snapshots().map((snapshot) {
      final Map<String, int> counts = {};
      final now = DateTime.now();

      for (int i = 11; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        final key = DateFormat('MMM yyyy').format(month);
        counts[key] = 0;
      }

      for (var doc in snapshot.docs) {
        final date = (doc.data()['createdAt'] as Timestamp?)?.toDate();
        if (date != null) {
          final key = DateFormat('MMM yyyy').format(date);
          if (counts.containsKey(key)) {
            counts[key] = (counts[key] ?? 0) + 1;
          }
        }
      }
      return counts;
    });
  }

  Future<void> reopenIntervention(String interventionId) async {
    await _firestore.collection('interventions').doc(interventionId).update({
      'status': InterventionStatus.InProgress.name,
      'reportDate': null, // Clear the old report date
      'clientSignatureBase64': null, // Clear the old signatures
      'managerSignatureBase64': null,
    });
  }
}