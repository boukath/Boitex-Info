// lib/features/sections/installation_request_page.dart

import 'package:boitex_info/auth/data/user_service.dart';
import 'package:boitex_info/auth/models/boitex_user.dart';
// --- FIXED: Corrected the malformed import path ---
import 'package:boitex_info/core/roles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'installation_domain.dart';
import 'installation_service.dart';

class InstallationRequestPage extends StatefulWidget {
  final BoitexUser currentUser;
  const InstallationRequestPage({super.key, required this.currentUser});

  @override
  State<InstallationRequestPage> createState() => _InstallationRequestPageState();
}

class _InstallationRequestPageState extends State<InstallationRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _client = TextEditingController();
  final _location = TextEditingController();
  DateTime _date = DateTime.now();
  final _phone = TextEditingController();
  final _modelType = TextEditingController();
  final _config = TextEditingController();
  final _accessories = TextEditingController();
  final _comment = TextEditingController();
  String _level = 'Green';

  final _service = InstallationService();
  bool _saving = false;

  List<BoitexUser> _assignableUsers = [];
  List<BoitexUser> _assignedUsers = [];
  bool _isLoadingUsers = true;

  final List<Map<String, dynamic>> _defaultChecklist = [
    {'title': 'Independent Electrical Source Confirmed', 'isChecked': false},
    {'title': '24/7 Power Source Verified', 'isChecked': false},
    {'title': 'Electrical Stabilizer (Stabilisateur) Present', 'isChecked': false},
    {'title': 'Pedestal Placement is Secure and Safe', 'isChecked': false},
    {'title': 'Environment Suitable for System (No Interference)', 'isChecked': false},
    {'title': '1.80m Perimeter is Clear of Obstructions', 'isChecked': false},
    {'title': 'System Powered On', 'isChecked': false},
    {'title': 'System Configured and Tuned', 'isChecked': false},
    {'title': 'Detection Accuracy Test Passed', 'isChecked': false},
    {'title': 'Staff Training on Basic Use Completed', 'isChecked': false},
  ];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (widget.currentUser.role.canAssignTickets) {
      final users = await UserService().getAllUsers();
      if (mounted) {
        setState(() {
          _assignableUsers = users;
          _isLoadingUsers = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isLoadingUsers = false);
      }
    }
  }

  @override
  void dispose() {
    _client.dispose();
    _location.dispose();
    _phone.dispose();
    _modelType.dispose();
    _config.dispose();
    _accessories.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    try {
      final newCode = await _service.getNextCode();
      final newInstallation = Installation(
        code: newCode,
        clientName: _client.text.trim(),
        storeLocation: _location.text.trim(),
        date: _date,
        phone: _phone.text.trim(),
        modelType: _modelType.text.trim(),
        config: _config.text.trim(),
        accessories: _accessories.text.trim(),
        level: _level,
        comment: _comment.text.trim(),
        checklist: _defaultChecklist,
        assignedTechnicianIds: _assignedUsers.map((u) => u.uid).toList(),
        assignedTechnicianNames: _assignedUsers.map((u) => u.fullName).toList(),
        status: _assignedUsers.isNotEmpty ? InstallationStatus.Assigned : InstallationStatus.New,
      );
      final user = FirebaseAuth.instance.currentUser;
      final userName = user?.displayName ?? user?.email ?? 'System Action';

      await _service.addInstallation(newInstallation, userName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved ${newInstallation.code}')));
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
      appBar: AppBar(title: const Text('New Installation Request')),
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
                    _text('Client Name', _client, validator: _required),
                    const SizedBox(height: 12),
                    _text('Store Location', _location, validator: _required),
                    const SizedBox(height: 12),
                    _dateField('Date', _date, (d) => setState(() => _date = d ?? _date)),
                    const SizedBox(height: 12),
                    _text('Phone', _phone, keyboardType: TextInputType.phone, validator: _required),
                    const SizedBox(height: 12),
                    _text('System Model/Type', _modelType, validator: _required),
                    const SizedBox(height: 12),
                    _text('Config', _config, lines: 2),
                    const SizedBox(height: 12),
                    _text('Accessories', _accessories, lines: 2),
                    const SizedBox(height: 12),
                    _levelPicker(),
                    const SizedBox(height: 12),
                    if (widget.currentUser.role.canAssignTickets) ...[
                      _buildMultiAssignmentSelector(),
                      const SizedBox(height: 12),
                    ],
                    _text('Comment', _comment, lines: 3),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving...' : 'Save Request'),
                      onPressed: _saving ? null : _save,
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

  Widget _buildMultiAssignmentSelector() {
    if (_isLoadingUsers) {
      return InputDecorator(
        decoration: const InputDecoration(labelText: 'Assign to'),
        child: Row(
          children: const [
            SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Text('Loading users...'),
          ],
        ),
      );
    }
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Assign Technicians',
        prefixIcon: Icon(Icons.group_add_outlined),
      ),
      child: InkWell(
        onTap: _showMultiSelectDialog,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _assignedUsers.isEmpty
              ? Text('Select one or more technicians', style: TextStyle(color: Theme.of(context).hintColor))
              : Wrap(
            spacing: 6.0, runSpacing: 6.0,
            children: _assignedUsers.map((user) => Chip(
              label: Text(user.fullName),
              onDeleted: () => setState(() => _assignedUsers.remove(user)),
            )).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _showMultiSelectDialog() async {
    final List<BoitexUser>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MultiSelectDialog(
          items: _assignableUsers,
          initialSelectedItems: _assignedUsers,
        );
      },
    );
    if (results != null) {
      setState(() => _assignedUsers = results);
    }
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
        child: Text(DateFormat.yMMMd().format(value)),
      ),
    );
  }

  Widget _levelPicker() {
    final levels = ['Green', 'Yellow', 'Red'];
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Level'),
      child: Wrap(
        spacing: 8,
        children: levels.map((lv) {
          final selected = _level == lv;
          return ChoiceChip(
            label: Text(lv),
            selected: selected,
            selectedColor: lv == 'Red' ? Colors.red.shade400 : lv == 'Yellow' ? Colors.yellow.shade600 : Colors.green.shade400,
            onSelected: (_) => setState(() => _level = lv),
          );
        }).toList(),
      ),
    );
  }
}

class _MultiSelectDialog extends StatefulWidget {
  final List<BoitexUser> items;
  final List<BoitexUser> initialSelectedItems;

  const _MultiSelectDialog({required this.items, required this.initialSelectedItems});

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<BoitexUser> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Technicians'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index];
            final isSelected = _selectedItems.any((selected) => selected.uid == item.uid);
            return CheckboxListTile(
              title: Text(item.fullName),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedItems.add(item);
                  } else {
                    _selectedItems.removeWhere((selected) => selected.uid == item.uid);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          child: const Text('Done'),
          onPressed: () => Navigator.of(context).pop(_selectedItems),
        ),
      ],
    );
  }
}