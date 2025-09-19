// lib/features/sections/installation_report_view_page.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'installation_domain.dart';
import 'installation_pdf_helper.dart';

class InstallationReportViewPage extends StatelessWidget {
  final Installation installation;

  const InstallationReportViewPage({super.key, required this.installation});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text('Installation: ${installation.code}'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final bytes = await InstallationPdfHelper.generateSingleReportPdf(installation);
              await Printing.layoutPdf(onLayout: (_) async => bytes);
            },
          ),
          IconButton(
            tooltip: 'Share Report',
            icon: const Icon(Icons.share_outlined),
            onPressed: () async {
              final bytes = await InstallationPdfHelper.generateSingleReportPdf(installation);
              await Printing.sharePdf(bytes: bytes, filename: 'Installation_${installation.code}.pdf');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(context, 'Request Details', [
            _kv('Client', installation.clientName),
            _kv('Store Location', installation.storeLocation),
            _kv('Request Date', dateFmt.format(installation.date)),
            _kv('Phone', installation.phone),
            _kv('Model/Type', installation.modelType),
            _kv('Config', installation.config),
            _kv('Accessories', installation.accessories),
            _kv('Priority Level', installation.level),
          ]),
          if (installation.checklist?.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Installation Checklist', [
              for (final item in installation.checklist!)
                _kv(
                  item['title'],
                  item['isChecked'] ? 'Completed' : 'Not Completed',
                  icon: item['isChecked']
                      ? const Icon(Icons.check_box_outlined, color: Colors.green)
                      : const Icon(Icons.check_box_outline_blank, color: Colors.grey),
                ),
            ]),
          ],
          if (installation.installedAssets?.isNotEmpty ?? false) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Installed Systems', [
              for (final system in installation.installedAssets!)
                _buildSystemView(system),
            ]),
          ],
          if (installation.isCompleted) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Completion Details', [
              _kv('Technician(s)', installation.completingTechnicianName ?? '-'),
              _kv('Manager', installation.managerName ?? '-'),
              _kv('Completion Date', installation.completionDate != null ? dateFmt.format(installation.completionDate!) : '-'),
              if (installation.comment.isNotEmpty) _kv('Comment', installation.comment),
            ]),
          ],
          if (installation.managerSignaturePng != null || installation.clientSignaturePng != null) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Signatures', [
              if (installation.managerSignaturePng != null)
                _signatureView('Manager Signature', installation.managerSignaturePng!),
              if (installation.managerSignaturePng != null && installation.clientSignaturePng != null)
                const SizedBox(height: 16),
              if (installation.clientSignaturePng != null)
                _signatureView('Client Signature', installation.clientSignaturePng!),
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