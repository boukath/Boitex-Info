// lib/features/history/intervention_report_view_page.dart
import 'dart:convert';
import 'package:boitex_info/core/services/pdf_service.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class InterventionReportViewPage extends StatefulWidget {
  final Intervention intervention;
  const InterventionReportViewPage({super.key, required this.intervention});

  @override
  State<InterventionReportViewPage> createState() => _InterventionReportViewPageState();
}

class _InterventionReportViewPageState extends State<InterventionReportViewPage> {
  bool _isSharing = false;

  Future<void> _shareReport() async {
    setState(() => _isSharing = true);
    try {
      final pdfService = PdfService();
      final pdfBytes = await pdfService.generateInterventionReport(widget.intervention);
      await Printing.sharePdf(bytes: pdfBytes, filename: 'report-${widget.intervention.code}.pdf');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to share PDF: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report: ${widget.intervention.code}'),
        actions: [
          if (_isSharing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)),
            )
          else
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: _shareReport,
            ),
        ],
      ),
      // FIX: Added the body content back in
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Client & Intervention Details', context),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Client:', widget.intervention.clientName),
                    _buildInfoRow('Location:', widget.intervention.storeLocation),
                    _buildInfoRow('Date:', DateFormat.yMMMd().format(widget.intervention.date)),
                    _buildInfoRow('Issue:', widget.intervention.issue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Technician Report', context),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildInfoRow('Technician:', widget.intervention.technicianName ?? 'N/A'),
                    _buildInfoRow('Arrival:', widget.intervention.arrivalTime ?? 'N/A'),
                    _buildInfoRow('Departure:', widget.intervention.departureTime ?? 'N/A'),
                    const Divider(height: 24),
                    _buildInfoBlock('Diagnostic:', widget.intervention.diagnostic ?? 'N/A'),
                    _buildInfoBlock('Work Performed:', widget.intervention.workDone ?? 'N/A'),
                    _buildInfoBlock('Parts Used:', widget.intervention.partsUsed ?? 'N/A'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Signatures', context),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (widget.intervention.clientSignatureBase64 != null) ...[
                      const Text('Client Signature', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Image.memory(base64Decode(widget.intervention.clientSignatureBase64!)),
                      const Divider(height: 24),
                    ],
                    if (widget.intervention.managerSignatureBase64 != null) ...[
                      const Text('Manager Signature', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Image.memory(base64Decode(widget.intervention.managerSignatureBase64!)),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: TextStyle(color: Colors.grey.shade600)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}