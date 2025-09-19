// lib/features/sections/sav_pdf_helper.dart

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'repairs_sav_domain.dart';

class SavPdfHelper {
  static Future<Uint8List> generateSingleReportPdf(SavTicket ticket) async {
    final doc = pw.Document();
    final logoBytes = await rootBundle.load('assets/images/boitex_logo.png');
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final dateFmt = DateFormat.yMMMd();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildPdfTheme(logo),
        header: (context) => _buildPdfHeader(context, 'SAV Report: ${ticket.code}'),
        build: (context) => [
          pw.Text('Ticket Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          pw.Divider(height: 8),
          _kvTable([
            ['Ticket Code', ticket.code],
            ['Client Name', ticket.client],
            ['Creation Date', dateFmt.format(ticket.date)],
            ['Arrival Date', ticket.arrivalDate != null ? dateFmt.format(ticket.arrivalDate!) : '-'],
          ]),

          if (ticket.repairedAssets?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 20),
            pw.Text('Equipment Details', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(height: 8),
            for (final system in ticket.repairedAssets!) ...[
              pw.SizedBox(height: 6),
              pw.Text(system['systemName'] ?? 'Unnamed System', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              _kvTable(
                ((system['components'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? []).map((asset) {
                  return [asset['model']?.toString() ?? '-', asset['serial']?.toString() ?? '-'];
                }).toList(),
                headers: ['Component Model', 'Serial Number'],
              ),
            ]
          ],

          pw.SizedBox(height: 20),
          pw.Text('Diagnosis & Repair Information', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
          pw.Divider(height: 8),
          _kvTable([
            ['Technician Diagnosis', ticket.diagnostic.isEmpty ? '-' : ticket.diagnostic],
            ['Parts Required', ticket.partsRequired.isEmpty ? '-' : ticket.partsRequired],
            ['Repair Performed', ticket.repairPerformed.isEmpty ? '-' : ticket.repairPerformed],
            ['Return Date', ticket.returnDate != null ? dateFmt.format(ticket.returnDate!) : '-'],
          ]),

          if (ticket.resolutionChecklist?.isNotEmpty ?? false) ...[
            pw.SizedBox(height: 20),
            pw.Text('Final Checklist', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(height: 8),
            _kvTable(
              ticket.resolutionChecklist!.map((item) {
                return [item['title'].toString(), item['isChecked'] ? '✓ Done' : '-'];
              }).toList(),
            ),
          ],

          if (ticket.intakeSignaturePng != null || ticket.clientSignaturePng != null) ...[
            pw.SizedBox(height: 24),
            pw.Text('Signatures', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
            pw.Divider(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (ticket.intakeSignaturePng != null)
                  pw.Column(children: [
                    pw.Text('Client Pickup Acknowledgment'),
                    pw.SizedBox(height: 4),
                    pw.Image(pw.MemoryImage(ticket.intakeSignaturePng!), height: 60),
                  ]),
                if (ticket.clientSignaturePng != null)
                  pw.Column(children: [
                    pw.Text('Client Final Sign-Off'),
                    pw.SizedBox(height: 4),
                    pw.Image(pw.MemoryImage(ticket.clientSignaturePng!), height: 60),
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
          child: pw.Opacity(opacity: 0.08, child: pw.Image(logo, height: 400)),
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