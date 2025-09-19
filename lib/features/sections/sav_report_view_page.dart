// lib/features/sections/sav_report_view_page.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'repairs_sav_domain.dart';
import 'sav_pdf_helper.dart';

class SavReportViewPage extends StatelessWidget {
  final SavTicket ticket;

  const SavReportViewPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text('SAV Report: ${ticket.code}'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final bytes = await SavPdfHelper.generateSingleReportPdf(ticket);
              await Printing.layoutPdf(onLayout: (_) async => bytes);
            },
          ),
          IconButton(
            tooltip: 'Share Report',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              final bytes = await SavPdfHelper.generateSingleReportPdf(ticket);
              await Printing.sharePdf(bytes: bytes, filename: 'SAV_Report_${ticket.code}.pdf');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(context, 'Ticket Details', [
            _kv('Client', ticket.client),
            _kv('Creation Date', dateFmt.format(ticket.date)),
            _kv('Arrival Date', ticket.arrivalDate != null ? dateFmt.format(ticket.arrivalDate!) : '-'),
          ]),
          if (ticket.repairedAssets?.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Equipment Details', [
              for (final system in ticket.repairedAssets!)
                _buildSystemView(system),
            ]),
          ],
          const SizedBox(height: 16),
          _buildSection(context, 'Diagnosis & Repair', [
            _kv('Technician Diagnosis', ticket.diagnostic),
            _kv('Parts Required', ticket.partsRequired.isEmpty ? '-' : ticket.partsRequired),
            _kv('Repair Performed', ticket.repairPerformed),
            _kv('Return Date', ticket.returnDate != null ? dateFmt.format(ticket.returnDate!) : '-'),
          ]),
          if (ticket.resolutionChecklist?.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Final Checklist', [
              for (final item in ticket.resolutionChecklist!)
                _kv(
                  item['title'],
                  item['isChecked'] ? 'Completed' : 'Not Completed',
                  icon: item['isChecked']
                      ? const Icon(Icons.check_box_outlined, color: Colors.green)
                      : const Icon(Icons.check_box_outline_blank, color: Colors.grey),
                ),
            ]),
          ],
          if (ticket.intakeSignaturePng != null || ticket.clientSignaturePng != null) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Signatures', [
              if (ticket.intakeSignaturePng != null)
                _signatureView('Client Pickup Acknowledgment', ticket.intakeSignaturePng!),
              if (ticket.intakeSignaturePng != null && ticket.clientSignaturePng != null)
                const SizedBox(height: 16),
              if (ticket.clientSignaturePng != null)
                _signatureView('Client Final Sign-Off', ticket.clientSignaturePng!),
            ]),
          ],
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

  Widget _buildSystemView(Map<String, dynamic> system) {
    final systemName = system['systemName'] as String? ?? 'Unnamed System';
    final components = (system['components'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(systemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          if (components.isEmpty)
            const Text('  - No components listed', style: TextStyle(fontStyle: FontStyle.italic)),
          for (final asset in components)
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Text('• ${asset['model'] ?? '-'} (SN: ${asset['serial'] ?? 'N/A'})'),
            ),
        ],
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

  Widget _kv(String key, String value, {Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(key, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          if (icon != null) ...[icon, const SizedBox(width: 8)],
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}