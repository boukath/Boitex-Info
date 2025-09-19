// lib/features/sections/installation_pdf_helper.dart

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'installation_domain.dart';

class InstallationPdfHelper {
  static Future<Uint8List> generateSingleReportPdf(Installation installation) async {
    final doc = pw.Document();
    final logoBytes = await rootBundle.load('assets/images/boitex_logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final dateFmt = DateFormat.yMMMd();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildPdfTheme(logo),
        header: (context) => _buildPdfHeader(context, 'Installation Report: ${installation.code}'),
        build: (context) => [
          pw.Text('Request Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          pw.Divider(height: 8),
          _kvTable([
            ['Request Code', installation.code],
            ['Client Name', installation.clientName],
            ['Store Location', installation.storeLocation],
            ['Request Date', dateFmt.format(installation.date)],
            ['Phone', installation.phone],
            ['Model/Type', installation.modelType],
            ['Configuration', installation.config],
            ['Accessories', installation.accessories],
            ['Priority Level', installation.level],
          ]),

          if (installation.checklist?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 24),
            pw.Text('Installation Checklist', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(height: 8),
            _kvTable(
              installation.checklist!.map((item) {
                return [item['title'].toString(), item['isChecked'] ? '✓ Done' : '-'];
              }).toList(),
            ),
          ],

          if (installation.installedAssets?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 24),
            pw.Text('Installed Systems', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(height: 8),
            for (final system in installation.installedAssets!) ...[
              pw.SizedBox(height: 8),
              pw.Text(system['systemName'] ?? 'Unnamed System', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              _kvTable(
                ((system['components'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? []).map((asset) {
                  return [asset['model']?.toString() ?? '-', asset['serial']?.toString() ?? '-'];
                }).toList(),
                headers: ['Component Model', 'Serial Number'],
              ),
            ]
          ],

          if(installation.isCompleted) ...[
            pw.SizedBox(height: 24),
            pw.Text('Completion Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(height: 8),
            _kvTable([
              ['Technician(s)', installation.completingTechnicianName ?? '-'],
              ['Manager', installation.managerName ?? '-'],
              ['Completion Date', installation.completionDate != null ? dateFmt.format(installation.completionDate!) : '-'],
              ['Comment', installation.comment.isEmpty ? '-' : installation.comment],
            ]),
          ],

          if (installation.managerSignaturePng != null || installation.clientSignaturePng != null) ...[
            pw.SizedBox(height: 24),
            pw.Text('Signatures:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (installation.managerSignaturePng != null)
                  pw.Column(children: [
                    pw.Text('Manager Signature'),
                    pw.SizedBox(height: 4),
                    pw.Image(pw.MemoryImage(installation.managerSignaturePng!), height: 60),
                  ]),
                if (installation.clientSignaturePng != null)
                  pw.Column(children: [
                    pw.Text('Client Signature'),
                    pw.SizedBox(height: 4),
                    pw.Image(pw.MemoryImage(installation.clientSignaturePng!), height: 60),
                  ]),
              ],
            ),
          ]
        ],
      ),
    );

    return doc.save();
  }

  static pw.PageTheme _buildPdfTheme(pw.MemoryImage logo) {
    return pw.PageTheme(
      margin: const pw.EdgeInsets.all(36),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Center(
          child: pw.Opacity(
            opacity: 0.08,
            child: pw.Image(logo, height: 400),
          ),
        ),
      ),
    );
  }

  static pw.Widget _buildPdfHeader(pw.Context context, String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
          pw.Text(DateFormat.yMMMMd().format(DateTime.now()), style: const pw.TextStyle(color: PdfColors.grey)),
        ],
      ),
    );
  }

  static pw.Table _kvTable(List<List<String>> data, {List<String>? headers}) {
    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      cellAlignment: pw.Alignment.centerLeft,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellStyle: const pw.TextStyle(),
      columnWidths: {
        0: const pw.FixedColumnWidth(150),
        1: const pw.FlexColumnWidth(),
      },
      border: const pw.TableBorder(
        top: pw.BorderSide.none,
        bottom: pw.BorderSide.none,
        left: pw.BorderSide.none,
        right: pw.BorderSide.none,
        horizontalInside: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
        verticalInside: pw.BorderSide.none,
      ),
    );
  }
}