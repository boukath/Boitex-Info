// lib/features/sections/installation_completion_page.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'installation_domain.dart';
import 'installation_service.dart';
import 'barcode_scanner_page.dart';

class _ComponentLine {
  final TextEditingController model = TextEditingController();
  final TextEditingController serial = TextEditingController();
  void dispose() {
    model.dispose();
    serial.dispose();
  }
}

class _SystemLine {
  final TextEditingController name = TextEditingController();
  final List<_ComponentLine> components = [_ComponentLine()];
  void dispose() {
    name.dispose();
    for (var comp in components) {
      comp.dispose();
    }
  }
}

class InstallationCompletionPage extends ConsumerStatefulWidget {
  final Installation installation;
  const InstallationCompletionPage({super.key, required this.installation});

  @override
  ConsumerState<InstallationCompletionPage> createState() => _InstallationCompletionPageState();
}

class _InstallationCompletionPageState extends ConsumerState<InstallationCompletionPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateFmt = DateFormat.yMMMd();
  final _service = InstallationService();
  bool _saving = false;

  DateTime _completionDate = DateTime.now();
  final _tech = TextEditingController();
  final _mgr = TextEditingController();
  final _comment = TextEditingController();

  // --- 1. REPLACED TextEditingController with a simple String to hold the rating ---
  String? _selectedSatisfactionRating;

  final _clientSigController = SignatureController(penStrokeWidth: 2, penColor: Colors.black);

  late List<Map<String, dynamic>> _checklist;
  final List<_SystemLine> _systemLines = [_SystemLine()];

  @override
  void initState() {
    super.initState();
    _checklist = List<Map<String, dynamic>>.from(widget.installation.checklist ?? []);

    final assignedNames = widget.installation.assignedTechnicianNames;
    if (assignedNames != null && assignedNames.isNotEmpty) {
      _tech.text = assignedNames.join(', ');
    }
  }

  @override
  void dispose() {
    _tech.dispose();
    _mgr.dispose();
    _comment.dispose();
    _clientSigController.dispose();
    for (var system in _systemLines) {
      system.dispose();
    }
    super.dispose();
  }

  Future<void> _scanBarcode(TextEditingController controller) async {
    final String? barcodeValue = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (barcodeValue != null && barcodeValue.isNotEmpty) {
      setState(() {
        controller.text = barcodeValue;
      });
    }
  }

  Future<void> _save() async {
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
      final clientPng = await _clientSigController.toPngBytes();

      final systems = _systemLines
          .where((sys) => sys.name.text.isNotEmpty)
          .map((sys) => {
        'systemName': sys.name.text.trim(),
        'components': sys.components
            .where((comp) => comp.model.text.isNotEmpty || comp.serial.text.isNotEmpty)
            .map((comp) => {'model': comp.model.text.trim(), 'serial': comp.serial.text.trim()})
            .toList(),
      })
          .toList();

      final updatedInstallation = widget.installation.copyWith(
        completionDate: _completionDate,
        completingTechnicianName: _tech.text.trim(),
        managerName: _mgr.text.trim(),
        comment: _comment.text.trim(),
        clientSignaturePng: clientPng,
        status: InstallationStatus.Completed,
        checklist: _checklist,
        installedAssets: systems,
        // --- 2. UPDATED the save logic to use the selected rating ---
        clientSatisfactionNote: _selectedSatisfactionRating,
      );

      await _service.updateInstallation(updatedInstallation, currentUser.fullName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Completion saved for ${widget.installation.code}')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
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
      appBar: AppBar(title: Text('Complete ${widget.installation.code}')),
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
                    _kv('Client', widget.installation.clientName),
                    _kv('Store Location', widget.installation.storeLocation),
                    _kv('Model/Type', widget.installation.modelType),
                    const Divider(height: 24),
                    _buildChecklistSection(),
                    const Divider(height: 24),
                    _buildAssetSection(),
                    const Divider(height: 24),
                    _dateField('Completion Date', _completionDate, (d) => setState(() => _completionDate = d ?? _completionDate)),
                    const SizedBox(height: 12),
                    _text('Technician Name(s)', _tech, validator: _required),
                    const SizedBox(height: 12),
                    _text('Manager Name', _mgr, validator: _required),
                    const SizedBox(height: 12),
                    _text('Comment', _comment, lines: 3),
                    const SizedBox(height: 12),

                    // --- 3. REPLACED the text field with a DropdownButtonFormField ---
                    DropdownButtonFormField<String>(
                      value: _selectedSatisfactionRating,
                      decoration: const InputDecoration(
                        labelText: 'Client Satisfaction Rating',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select a rating (1-10)'),
                      items: List.generate(10, (index) {
                        final value = (index + 1).toString();
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSatisfactionRating = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 24), // Added extra space

                    _buildSignaturePad(context, 'Client Signature (Sign-Off)', _clientSigController),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                        label: Text(_saving ? 'Saving...' : 'Save Completion'),
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

  // ... (the rest of the file and helper methods remain the same)

  Widget _buildChecklistSection() {
    if (_checklist.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Installation Checklist',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < _checklist.length; i++)
          CheckboxListTile(
            title: Text(_checklist[i]['title']),
            value: _checklist[i]['isChecked'],
            onChanged: (bool? value) {
              setState(() {
                _checklist[i]['isChecked'] = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }

  Widget _buildAssetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Installed Systems', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (int i = 0; i < _systemLines.length; i++)
          _buildSystemCard(i),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('Add System'),
            onPressed: () => setState(() => _systemLines.add(_SystemLine())),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemCard(int systemIndex) {
    final systemLine = _systemLines[systemIndex];
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: systemLine.name,
                    decoration: const InputDecoration(
                      labelText: 'System Name',
                      prefixIcon: Icon(Icons.apps),
                    ),
                    validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: _systemLines.length > 1 ? () => setState(() => _systemLines.removeAt(systemIndex)) : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            for (int j = 0; j < systemLine.components.length; j++)
              _buildComponentRow(systemLine, j),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Component'),
                onPressed: () => setState(() => systemLine.components.add(_ComponentLine())),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentRow( _SystemLine systemLine, int componentIndex) {
    final componentLine = systemLine.components[componentIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: componentLine.model,
              decoration: const InputDecoration(labelText: 'Component Model'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: componentLine.serial,
              decoration: InputDecoration(
                labelText: 'Serial Number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                  tooltip: 'Scan Serial Number',
                  onPressed: () => _scanBarcode(componentLine.serial),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: systemLine.components.length > 1 ? () => setState(() => systemLine.components.removeAt(componentIndex)) : null,
          ),
        ],
      ),
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

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  Widget _text(String label, TextEditingController c, {int lines = 1, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return TextFormField(
      controller: c,
      minLines: lines,
      maxLines: lines,
      keyboardType: keyboardType,
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
          firstDate: DateTime(now.year - 3),
          lastDate: DateTime(now.year + 3),
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