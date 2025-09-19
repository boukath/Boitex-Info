// lib/features/sections/technician_report_page.dart

import 'dart:convert';
import 'dart:typed_data';

import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';

import 'intervention_service.dart';

class TechnicianReportPage extends StatefulWidget {
  final Intervention intervention;
  const TechnicianReportPage({super.key, required this.intervention});

  @override
  State<TechnicianReportPage> createState() => _TechnicianReportPageState();
}

class _TechnicianReportPageState extends State<TechnicianReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _tech = TextEditingController();
  final _mgr = TextEditingController();
  final _modelType = TextEditingController();
  final _diagnostic = TextEditingController();
  final _workDone = TextEditingController();
  final _parts = TextEditingController();
  final _dateFmt = DateFormat.yMMMd();
  DateTime _date = DateTime.now();
  TimeOfDay? _arr;
  TimeOfDay? _dep;

  final _sigController = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
  final _service = InterventionService();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final assignedNames = widget.intervention.assignedTechnicianNames;
    if (assignedNames != null && assignedNames.isNotEmpty) {
      _tech.text = assignedNames.join(', ');
    }
  }

  @override
  void dispose() {
    _tech.dispose();
    _mgr.dispose();
    _modelType.dispose();
    _diagnostic.dispose();
    _workDone.dispose();
    _parts.dispose();
    _sigController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    try {
      final sigBytes = await _sigController.toPngBytes();
      final sigBase64 = sigBytes != null ? base64Encode(sigBytes) : null;

      final updatedIntervention = widget.intervention.copyWith(
        technicianName: _tech.text.trim(),
        managerName: _mgr.text.trim().isEmpty ? null : _mgr.text.trim(),
        reportDate: _date,
        arrivalTime: _arr?.format(context) ?? '',
        departureTime: _dep?.format(context) ?? '',
        modelType: _modelType.text.trim(),
        diagnostic: _diagnostic.text.trim(),
        workDone: _workDone.text.trim(),
        partsUsed: _parts.text.trim(),
        managerSignatureBase64: sigBase64,
        status: InterventionStatus.Resolved,
      );

      await _service.updateIntervention(updatedIntervention);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted and status set to Resolved.')),
      );

      Navigator.pop(context, true);

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Operation failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final intervention = widget.intervention;
    return Scaffold(
      appBar: AppBar(title: Text('Report — ${intervention.code}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Client', intervention.clientName),
                    _kv('Store', intervention.storeLocation),
                    _kv('Issue', intervention.issue),
                    const Divider(height: 24),
                    _dateField('Date', _date, (d) => setState(() => _date = d ?? _date)),
                    const SizedBox(height: 12),
                    _text('Technician name(s)', _tech, validator: _required),
                    const SizedBox(height: 12),
                    _text('Manager name', _mgr),
                    const SizedBox(height: 12),
                    _timeField('Arrival time', _arr, (t) => setState(() => _arr = t)),
                    const SizedBox(height: 12),
                    _timeField('Departure time', _dep, (t) => setState(() => _dep = t)),
                    const SizedBox(height: 12),
                    _text('System Model/Type', _modelType, validator: _required),
                    const SizedBox(height: 12),
                    _text('Diagnostic', _diagnostic, lines: 3),
                    const SizedBox(height: 12),
                    _text('Work done', _workDone, lines: 3),
                    const SizedBox(height: 12),
                    _text('Parts changed/used', _parts, lines: 2),
                    const SizedBox(height: 12),
                    Text('Store Manager Signature', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                      ),
                      child: Signature(controller: _sigController, backgroundColor: Colors.transparent),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(onPressed: () => _sigController.clear(), child: const Text('Clear signature')),
                        const Spacer(),
                        FilledButton.icon(
                          icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                          label: Text(_saving ? 'Saving...' : 'Save Report'),
                          onPressed: _saving ? null : _submit,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  Widget _text(String label, TextEditingController c, {int lines = 1, String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      minLines: lines,
      maxLines: lines,
      validator: validator,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _dateField(String label, DateTime value, ValueChanged<DateTime?> onChanged) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(now.year - 2),
          lastDate: DateTime(now.year + 2),
          initialDate: value,
        );
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(_dateFmt.format(value)),
      ),
    );
  }

  Widget _timeField(String label, TimeOfDay? value, ValueChanged<TimeOfDay?> onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: value ?? TimeOfDay.now());
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(value == null ? 'Pick time' : value.format(context)),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}