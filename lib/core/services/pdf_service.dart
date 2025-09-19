// lib/core/services/pdf_service.dart
import 'dart:convert'; // FIX: Changed to dart:convert
import 'dart:typed_data'; // FIX: Changed to dart:typed_data
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<Uint8List> generateInterventionReport(Intervention intervention) async {
    final doc = pw.Document();

    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/boitex_logo.png')).buffer.asUint8List(),
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(logoImage, intervention),
              pw.Divider(height: 20),
              _buildSectionTitle('Client & Intervention Details'),
              _buildInfoTable({
                'Client:': intervention.clientName,
                'Location:': intervention.storeLocation,
                'Date:': DateFormat.yMMMd().format(intervention.date),
                'Issue:': intervention.issue,
              }),
              pw.SizedBox(height: 20),
              _buildSectionTitle('Technician Report'),
              _buildInfoTable({
                'Technician:': intervention.technicianName ?? 'N/A',
                'Arrival:': intervention.arrivalTime ?? 'N/A',
                'Departure:': intervention.departureTime ?? 'N/A',
                'Diagnostic:': intervention.diagnostic ?? 'N/A',
                'Work Performed:': intervention.workDone ?? 'N/A',
                'Parts Used:': intervention.partsUsed ?? 'N/A',
              }),
              pw.Spacer(),
              _buildSignatures(intervention),
              pw.Divider(height: 20),
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text('Thank you for your business!', style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey)),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(pw.MemoryImage logo, Intervention i) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.SizedBox(height: 50, width: 150, child: pw.Image(logo)),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Intervention Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Text(i.code, style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey700)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold));
  }

  pw.Widget _buildInfoTable(Map<String, String> data) {
    return pw.Table(
      columnWidths: {
        0: const pw.FixedColumnWidth(120),
        1: const pw.FlexColumnWidth(),
      },
      children: data.entries.map((entry) {
        return pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(entry.key, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(entry.value),
            ),
          ],
        );
      }).toList(),
    );
  }

  pw.Widget _buildSignatures(Intervention intervention) {
    final clientSig = intervention.clientSignatureBase64 != null ? pw.MemoryImage(base64Decode(intervention.clientSignatureBase64!)) : null;
    final managerSig = intervention.managerSignatureBase64 != null ? pw.MemoryImage(base64Decode(intervention.managerSignatureBase64!)) : null;

    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          if (clientSig != null)
            pw.Column(
                children: [
                  pw.Container(height: 80, width: 150, child: pw.Image(clientSig)),
                  pw.Container(width: 150, child: pw.Divider()),
                  pw.Text('Client Signature'),
                ]
            ),
          if (managerSig != null)
            pw.Column(
                children: [
                  pw.Container(height: 80, width: 150, child: pw.Image(managerSig)),
                  pw.Container(width: 150, child: pw.Divider()),
                  pw.Text('Manager Signature'),
                ]
            ),
        ]
    );
  }
}