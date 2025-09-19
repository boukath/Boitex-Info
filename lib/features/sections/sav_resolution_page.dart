// lib/features/sections/sav_resolution_page.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'repairs_sav_domain.dart';
import 'repairs_sav_service.dart';

class SavResolutionPage extends ConsumerStatefulWidget {
  final SavTicket ticket;
  const SavResolutionPage({super.key, required this.ticket});

  @override
  ConsumerState<SavResolutionPage> createState() => _SavResolutionPageState();
}

class _SavResolutionPageState extends ConsumerState<SavResolutionPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = SavService();
  bool _saving = false;

  final _repairPerformedController = TextEditingController();
  DateTime? _returnDate;
  final _clientSigController = SignatureController(penStrokeWidth: 2, penColor: Colors.black);

  late List<Map<String, dynamic>> _resolutionChecklist;

  @override
  void initState() {
    super.initState();
    _repairPerformedController.text = widget.ticket.repairPerformed;
    _returnDate = widget.ticket.returnDate;
    _resolutionChecklist = List<Map<String, dynamic>>.from(
        widget.ticket.resolutionChecklist ?? [
          {'title': 'Functionality Tested', 'isChecked': false},
          {'title': 'Device Cleaned', 'isChecked': false},
          {'title': 'Client Notified & Approved', 'isChecked': false},
        ]
    );
  }

  @override
  void dispose() {
    _repairPerformedController.dispose();
    _clientSigController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    final currentUser = ref.read(boitexUserProvider).value;
    if (currentUser == null) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: User not found.')));
      }
      setState(() => _saving = false);
      return;
    }

    try {
      final clientPng = await _clientSigController.toPngBytes();

      final updatedTicket = widget.ticket.copyWith(
        repairPerformed: _repairPerformedController.text.trim(),
        returnDate: _returnDate,
        resolutionChecklist: _resolutionChecklist,
        clientSignaturePng: clientPng,
        status: SavStatus.ReturnedToClient,
      );

      await _service.updateTicket(updatedTicket, currentUser.fullName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Resolution saved.')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save resolution: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resolve: ${widget.ticket.code}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Client', widget.ticket.client),
                    _kv('Diagnostic', widget.ticket.diagnostic.isEmpty ? '-' : widget.ticket.diagnostic),
                    _kv('Parts Required', widget.ticket.partsRequired.isEmpty ? '-' : widget.ticket.partsRequired),
                    const Divider(height: 24),

                    TextFormField(
                      controller: _repairPerformedController,
                      decoration: const InputDecoration(labelText: 'Repair Performed'),
                      maxLines: 4,
                      validator: (val) => (val == null || val.isEmpty) ? 'This field is required' : null,
                    ),
                    const SizedBox(height: 12),

                    _buildChecklistSection(),
                    const Divider(height: 24),

                    _dateField('Return Date', _returnDate, (d) => setState(() => _returnDate = d)),
                    const SizedBox(height: 16),

                    _buildSignaturePad(context, 'Client Signature (Sign-Off)', _clientSigController),

                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_circle_outline),
                        label: Text(_saving ? 'Saving...' : 'Save Resolution'),
                        onPressed: _saving ? null : _save,
                      ),
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

  Widget _buildChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resolution Checklist', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (int i = 0; i < _resolutionChecklist.length; i++)
          CheckboxListTile(
            title: Text(_resolutionChecklist[i]['title']),
            value: _resolutionChecklist[i]['isChecked'],
            onChanged: (bool? value) {
              setState(() => _resolutionChecklist[i]['isChecked'] = value ?? false);
            },
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }

  Widget _buildSignaturePad(BuildContext context, String title, SignatureController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
          ),
          child: Signature(controller: controller, backgroundColor: Colors.transparent),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => controller.clear(), child: const Text('Clear')),
        ),
      ],
    );
  }

  Widget _dateField(String label, DateTime? value, ValueChanged<DateTime?> onChanged) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(context: context, firstDate: DateTime(now.year - 3), lastDate: DateTime(now.year + 3), initialDate: value ?? now);
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(value == null ? 'Pick a date' : DateFormat.yMMMd().format(value)),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}