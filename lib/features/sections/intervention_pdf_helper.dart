// lib/features/sections/intervention_pdf_helper.dart

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'intervention_domain.dart';

class InterventionPdfHelper {
  static Future<Uint8List> generateSingleReportPdf(Intervention intervention) async {
    final doc = pw.Document();
    final logoBytes = await rootBundle.load('assets/images/boitex_logo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(36),
          theme: pw.ThemeData.withFont(
            base: pw.Font.helvetica(),
            bold: pw.Font.helveticaBold(),
          ),
        ),
        footer: (context) => _buildFooter(context),
        build: (context) => [
          _buildHeader(context, logoImage),
          pw.SizedBox(height: 20),
          _buildInfoInterventionTable(intervention),
          pw.SizedBox(height: 15),
          _buildEquipementTable(intervention),
          pw.SizedBox(height: 15),
          _buildFreeTextField('Avarie constatée', intervention.diagnostic ?? '-'),
          pw.SizedBox(height: 15),
          _buildFreeTextField('Travail Effectué', intervention.workDone ?? '-'),
          pw.SizedBox(height: 15),
          // NOTE: The current data model only supports a simple string for parts used.
          // A table for parts would require changes to the data model.
          _buildFreeTextField('Pièces Utilisées', intervention.partsUsed ?? '-'),
          pw.SizedBox(height: 15),
          _buildFreeTextField('Observations', intervention.comment),
          pw.SizedBox(height: 20),
          _buildValidationSection(intervention),
        ],
      ),
    );

    return doc.save();
  }

  // --- NEW: Header matching the reference document ---
  static pw.Widget _buildHeader(pw.Context context, pw.ImageProvider logo) {
    return pw.Table(
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(2),
      },
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Image(logo, height: 60, alignment: pw.Alignment.center),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text('BOITEXINFO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text("la facilité dans l'efficacité", style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                  pw.Text('Progiciels et Solution Antivol'),
                ],
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Container(
              alignment: pw.Alignment.center,
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text("FICHE D'INTERVENTION", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18)),
              // Using colSpan to make this cell span the entire width of the table
              colSpan: 2,
            ),
          ],
        ),
      ],
    );
  }

  // --- NEW: Recreates the "Informations Intervention" table ---
  static pw.Widget _buildInfoInterventionTable(Intervention intervention) {
    const headerStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9);
    const cellStyle = pw.TextStyle(fontSize: 9);
    const emptyCell = pw.Text('');

    // Helper to create styled cells
    pw.Widget headerCell(String text) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(text, style: headerStyle));
    pw.Widget dataCell(String text) => pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(text, style: cellStyle));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Informations Intervention', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: { for (var i = 0; i < 8; i++) i: const pw.FlexColumnWidth(1) },
          children: [
            pw.TableRow(
              children: [
                headerCell('Nº Intervention'), dataCell(intervention.code),
                headerCell('Date'), dataCell(DateFormat('dd/MM/yyyy').format(intervention.date)),
                headerCell('Client / Site'), dataCell(intervention.clientName),
                headerCell('Contact'), dataCell('-'), // Placeholder
              ],
            ),
            pw.TableRow(
              children: [
                headerCell('Technicien'), dataCell(intervention.technicianName ?? '-'),
                headerCell('Heure arrivée'), dataCell(intervention.arrivalTime ?? '-'),
                headerCell('Heure début'), dataCell('-'), // Placeholder
                headerCell('Heure fin'), dataCell('-'), // Placeholder
              ],
            ),
            pw.TableRow(
              children: [
                headerCell('Durée (heures)'), dataCell('-'), // Placeholder
                headerCell('Statut'), dataCell(intervention.status.name),
                headerCell('Référence Ticket'), dataCell(intervention.code),
                emptyCell, emptyCell, // Empty cells to maintain column structure
              ],
            ),
          ],
        ),
      ],
    );
  }

  // --- NEW: Recreates the "Équipement" table ---
  static pw.Widget _buildEquipementTable(Intervention intervention) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Équipement', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                  children: [
                    pw.Text('Produit', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Modèle', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('N° Série', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Localisation', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ]
              ),
              pw.TableRow(
                  children: [
                    pw.Container(height: 20, child: pw.Text(intervention.modelType ?? '-')),
                    pw.Container(height: 20, child: pw.Text(intervention.modelType ?? '-')),
                    pw.Container(height: 20, child: pw.Text('-')), // Placeholder
                    pw.Container(height: 20, child: pw.Text(intervention.storeLocation)),
                  ]
              ),
              pw.TableRow(
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text('Avarie signalée: ${intervention.issue}'),
                      colSpan: 4,
                      height: 40,
                      alignment: pw.Alignment.topLeft,
                    ),
                  ]
              ),
            ]
        ),
      ],
    );
  }

  // --- NEW: Helper for creating a titled, bordered text area ---
  static pw.Widget _buildFreeTextField(String title, String content) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(border: pw.Border.all()),
          constraints: const pw.BoxConstraints(minHeight: 60),
          child: pw.Text(content),
        ),
      ],
    );
  }

  // --- NEW: Recreates the two-column signature/validation section ---
  static pw.Widget _buildValidationSection(Intervention intervention) {
    // Helper to create a single signature box
    pw.Widget signatureBox(String title, Uint8List? signatureBytes) {
      return pw.Column(
        children: [
          pw.Container(
            width: double.infinity,
            color: PdfColors.grey200,
            padding: const pw.EdgeInsets.all(4),
            child: pw.Text(title, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            width: double.infinity,
            height: 100,
            padding: const pw.EdgeInsets.all(4),
            child: signatureBytes != null
                ? pw.Image(pw.MemoryImage(signatureBytes))
                : pw.Text(''),
          ),
        ],
      );
    }

    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Clôture et Validation', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: const {
                0: pw.FlexColumnWidth(1),
                1: pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                    children: [
                      // NOTE: Using the "managerSignature" from the app for the technician's validation
                      signatureBox('Validation Technicien (Signature)', intervention.managerSignatureBytes),
                      // NOTE: The app currently doesn't capture a client signature, but the data model supports it.
                      signatureBox('Validation Client (Signature & Cachet)', intervention.clientSignatureBytes),
                    ]
                )
              ]
          )
        ]
    );
  }

  // --- NEW: Footer matching the reference document ---
  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Center(
      child: pw.Text(
        'Document confidentiel - BOITEXINFO © 2025',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
      ),
    );
  }
}