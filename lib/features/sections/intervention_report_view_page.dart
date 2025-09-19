// lib/features/sections/intervention_report_view_page.dart

import 'dart:typed_data'; // FIXED: Added missing import for Uint8List
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'intervention_domain.dart';
import 'intervention_pdf_helper.dart';

class InterventionReportViewPage extends StatelessWidget {
  final Intervention intervention;

  const InterventionReportViewPage({super.key, required this.intervention});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text('Report: ${intervention.code}'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final bytes = await InterventionPdfHelper.generateSingleReportPdf(intervention);
              await Printing.layoutPdf(onLayout: (_) async => bytes);
            },
          ),
          IconButton(
            tooltip: 'Share Report',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              final bytes = await InterventionPdfHelper.generateSingleReportPdf(intervention);
              await Printing.sharePdf(bytes: bytes, filename: 'Intervention_${intervention.code}.pdf');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(context, 'Request Details', [
            _kv('Client', intervention.clientName),
            _kv('Store Location', intervention.storeLocation),
            _kv('Request Date', dateFmt.format(intervention.date)),
            _kv('Reported Issue', intervention.issue),
            _kv('Priority Level', intervention.level),
          ]),
          const SizedBox(height: 16),
          _buildSection(context, 'Technician Report', [
            _kv('Technician(s)', intervention.technicianName ?? '-'),
            _kv('Manager', intervention.managerName ?? '-'),
            _kv('Service Date', intervention.reportDate != null ? dateFmt.format(intervention.reportDate!) : '-'),
            _kv('Arrival Time', intervention.arrivalTime ?? '-'),
            _kv('Departure Time', intervention.departureTime ?? '-'),
            _kv('System Model/Type', intervention.modelType ?? '-'),
            _kv('Diagnostic', intervention.diagnostic ?? '-'),
            _kv('Work Performed', intervention.workDone ?? '-'),
            _kv('Parts Used', intervention.partsUsed ?? '-'),
          ]),
          if (intervention.managerSignatureBytes != null) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Signatures', [
              _signatureView('Manager Signature', intervention.managerSignatureBytes!),
            ]),
          ]
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _signatureView(String title, Uint8List signatureBytes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Image.memory(signatureBytes, height: 100, fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}