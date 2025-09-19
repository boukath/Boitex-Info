// lib/features/sections/intervention_report_edit_page.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:boitex_info/features/chat/intervention_chat_page.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:boitex_info/features/sections/intervention_domain.dart';
import 'package:boitex_info/features/sections/intervention_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'package:intl/intl.dart';

class InterventionReportEditPage extends ConsumerStatefulWidget {
  final Intervention intervention;
  const InterventionReportEditPage({super.key, required this.intervention});

  @override
  ConsumerState<InterventionReportEditPage> createState() => _InterventionReportEditPageState();
}

class _InterventionReportEditPageState extends ConsumerState<InterventionReportEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = InterventionService();
  bool _saving = false;

  final _diagnostic = TextEditingController();
  final _workDone = TextEditingController();
  final _modelType = TextEditingController();
  final _technicianName = TextEditingController();
  final _managerName = TextEditingController();

  DateTime _serviceDate = DateTime.now();
  TimeOfDay? _arrivalTime;
  TimeOfDay? _departureTime;

  final _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _diagnostic.text = widget.intervention.diagnostic ?? '';
    _workDone.text = widget.intervention.workDone ?? '';
    _modelType.text = widget.intervention.modelType ?? '';
    _technicianName.text = widget.intervention.technicianName ?? widget.intervention.assignedTechnicianNames?.join(', ') ?? '';
    _managerName.text = widget.intervention.managerName ?? '';
    _serviceDate = widget.intervention.reportDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _diagnostic.dispose();
    _workDone.dispose();
    _modelType.dispose();
    _technicianName.dispose();
    _managerName.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    final currentUser = ref.read(boitexUserProvider).value;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: User not found.')));
      }
      setState(() => _saving = false);
      return;
    }

    try {
      final Uint8List? signatureBytes = await _signatureController.toPngBytes();

      final updatedIntervention = widget.intervention.copyWith(
        diagnostic: _diagnostic.text.trim(),
        workDone: _workDone.text.trim(),
        modelType: _modelType.text.trim(),
        technicianName: _technicianName.text.trim(),
        managerName: _managerName.text.trim(),
        managerSignatureBase64: signatureBytes != null ? base64Encode(signatureBytes) : null,
        status: InterventionStatus.Resolved,
        reportDate: _serviceDate,
        arrivalTime: _arrivalTime?.format(context),
        departureTime: _departureTime?.format(context),
      );

      await _service.updateIntervention(updatedIntervention, currentUser.fullName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report saved successfully!')));
        Navigator.of(context)..pop()..pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save report: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: Text('Fill Report: ${widget.intervention.code}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Open Chat',
            onPressed: () {
              if (widget.intervention.id != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InterventionChatPage(
                      interventionId: widget.intervention.id!,
                      interventionCode: widget.intervention.code,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader('Technician & Service Details', Icons.badge_outlined),
            _buildTextField(_technicianName, 'Technician Name', Icons.engineering_outlined, validator: _required),
            _buildTextField(_managerName, 'Manager Name', Icons.supervisor_account_outlined),
            _buildTextField(_modelType, 'System Model/Type', Icons.devices_other_outlined),
            Row(
              children: [
                Expanded(child: _buildTimeField('Arrival Time', _arrivalTime, Icons.login_outlined, (time) => setState(() => _arrivalTime = time))),
                const SizedBox(width: 16),
                Expanded(child: _buildTimeField('Departure Time', _departureTime, Icons.logout_outlined, (time) => setState(() => _departureTime = time))),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader('Report Details', Icons.description_outlined),
            _buildTextField(_diagnostic, 'Diagnostic', Icons.biotech_outlined, lines: 3, validator: _required),
            _buildTextField(_workDone, 'Work Performed', Icons.build_circle_outlined, lines: 5, validator: _required),
            const SizedBox(height: 24),

            _buildSectionHeader('Manager Signature', Icons.draw_outlined),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Signature(
                      controller: _signatureController,
                      height: 150,
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        tooltip: 'Clear Signature',
                        onPressed: () => _signatureController.clear(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _saving ? null : _saveReport,
                icon: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_circle_outline),
                label: Text(_saving ? 'Saving...' : 'Complete & Save Report'),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController c, String label, IconData icon, {int lines = 1, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: c,
        minLines: lines,
        maxLines: lines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TimeOfDay? value, IconData icon, ValueChanged<TimeOfDay?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: value ?? TimeOfDay.now(),
          );
          if (pickedTime != null) {
            onChanged(pickedTime);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          child: Text(
            value?.format(context) ?? 'Set Time',
            style: TextStyle(
              color: value != null ? Colors.black87 : Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
}