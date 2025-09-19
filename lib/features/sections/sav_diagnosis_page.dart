// lib/features/sections/sav_diagnosis_page.dart
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signature/signature.dart';
import 'repairs_sav_domain.dart';
import 'repairs_sav_service.dart';

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

class SavDiagnosisPage extends ConsumerStatefulWidget {
  final SavTicket ticket;
  const SavDiagnosisPage({super.key, required this.ticket});

  @override
  ConsumerState<SavDiagnosisPage> createState() => _SavDiagnosisPageState();
}

class _SavDiagnosisPageState extends ConsumerState<SavDiagnosisPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = SavService();
  bool _saving = false;

  final _diagnosticController = TextEditingController();
  final _partsRequiredController = TextEditingController();
  final List<_SystemLine> _systemLines = [_SystemLine()];
  final _intakeSigController = SignatureController(penStrokeWidth: 2, penColor: Colors.black);
  SavStatus? _newStatus;

  @override
  void dispose() {
    _diagnosticController.dispose();
    _partsRequiredController.dispose();
    _intakeSigController.dispose();
    for (var system in _systemLines) {
      system.dispose();
    }
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

      final intakePng = await _intakeSigController.toPngBytes();

      final updatedTicket = widget.ticket.copyWith(
        repairedAssets: systems,
        diagnostic: _diagnosticController.text.trim(),
        partsRequired: _partsRequiredController.text.trim(),
        status: _newStatus ?? widget.ticket.status,
        intakeSignaturePng: intakePng,
      );

      await _service.updateTicket(updatedTicket, currentUser.fullName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Diagnosis saved.')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save diagnosis: $e')));
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
      appBar: AppBar(title: Text('Diagnose: ${widget.ticket.code}')),
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
                    Text('Client: ${widget.ticket.client}', style: Theme.of(context).textTheme.titleMedium),
                    const Divider(height: 24),

                    _buildAssetSection(),
                    const Divider(height: 24),

                    TextFormField(
                      controller: _diagnosticController,
                      decoration: const InputDecoration(labelText: 'Diagnostic Notes'),
                      maxLines: 4,
                      validator: (val) => (val == null || val.isEmpty) ? 'Diagnostic is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _partsRequiredController,
                      decoration: const InputDecoration(labelText: 'Parts Required (if any)'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<SavStatus>(
                      value: _newStatus,
                      decoration: const InputDecoration(labelText: 'Update Status'),
                      hint: const Text('Select next status'),
                      items: const [
                        DropdownMenuItem(value: SavStatus.RepairInProgress, child: Text('Repair In Progress')),
                        DropdownMenuItem(value: SavStatus.AwaitingParts, child: Text('Awaiting Parts')),
                        DropdownMenuItem(value: SavStatus.Repaired, child: Text('Repaired')),
                      ],
                      onChanged: (status) => setState(() => _newStatus = status),
                      validator: (status) => status == null ? 'Please update the status' : null,
                    ),
                    const SizedBox(height: 24),

                    _buildSignaturePad(context, 'Client Acknowledgment (for equipment pickup)', _intakeSigController),

                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                        label: Text(_saving ? 'Saving...' : 'Save Diagnosis'),
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

  Widget _buildAssetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Equipment for Repair', style: Theme.of(context).textTheme.titleLarge),
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
                    decoration: const InputDecoration(labelText: 'System Name', prefixIcon: Icon(Icons.apps)),
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
              decoration: const InputDecoration(labelText: 'Serial Number'),
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
}