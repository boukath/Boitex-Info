// lib/features/sections/intervention_loader_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:boitex_info/features/sections/technician_report_page.dart';

class InterventionLoaderPage extends StatelessWidget {
  final String interventionId;

  const InterventionLoaderPage({super.key, required this.interventionId});

  Future<Intervention?> _fetchIntervention() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('interventions')
          .doc(interventionId)
          .get();

      if (doc.exists) {
        return Intervention.fromJson(doc.data()!, doc.id);
      }
    } catch (e) {
      print("Error fetching intervention: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Intervention?>(
      future: _fetchIntervention(),
      builder: (context, snapshot) {
        // While loading, show a spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If we have data, navigate to the real page
        if (snapshot.hasData && snapshot.data != null) {
          // Use a post-frame callback to navigate after the build is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TechnicianReportPage(intervention: snapshot.data!),
              ),
            );
          });
        }

        // If there was an error or no data, show an error and a back button
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Could not load intervention. It may have been deleted.'),
            ),
          );
        }

        // Show a loading screen as a fallback
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}