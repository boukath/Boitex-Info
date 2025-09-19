// lib/features/sections/new_sav_ticket_page.dart

import 'package:boitex_info/auth/data/user_service.dart';
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/core/roles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'repairs_sav_domain.dart';
import 'repairs_sav_service.dart';

class NewSavTicketPage extends StatefulWidget {
  final BoitexUser currentUser;
  const NewSavTicketPage({super.key, required this.currentUser});

  @override
  State<NewSavTicketPage> createState() => _NewSavTicketPageState();
}

class _NewSavTicketPageState extends State<NewSavTicketPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = SavService();
  bool _saving = false;

  DateTime _date = DateTime.now();
  final _client = TextEditingController();
  DateTime? _arrivalDate;
  final _comment = TextEditingController();

  List<BoitexUser> _assignableUsers = [];
  List<BoitexUser> _assignedUsers = [];
  bool _isLoadingUsers = true;

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
      if (mounted) setState(() => _isLoadingUsers = false);
    }
  }

  @override
  void dispose() {
    _client.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    try {
      final newCode = await _service.getNextCode();
      final newTicket = SavTicket(
        code: newCode,
        date: _date,
        client: _client.text.trim(),
        arrivalDate: _arrivalDate,
        comment: _comment.text.trim(),
        assignedTechnicianIds: _assignedUsers.map((u) => u.uid).toList(),
        assignedTechnicianNames: _assignedUsers.map((u) => u.fullName).toList(),
        status: _assignedUsers.isNotEmpty ? SavStatus.Assigned : SavStatus.New,
      );
      final user = FirebaseAuth.instance.currentUser;
      final userName = user?.displayName ?? user?.email ?? 'System Action';


      await _service.addTicket(newTicket, userName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved ${newTicket.code}')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New SAV Ticket')),
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
                    _dateField('Creation Date', _date, (d) => setState(() => _date = d ?? _date)),
                    const SizedBox(height: 12),
                    _dateField('Arrival Date', _arrivalDate, (d) => setState(() => _arrivalDate = d)),
                    const SizedBox(height: 12),
                    if (widget.currentUser.role.canAssignTickets) ...[
                      _buildMultiAssignmentSelector(),
                      const SizedBox(height: 12),
                    ],
                    _text('Comment', _comment, lines: 3),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                      label: Text(_saving ? 'Saving...' : 'Save Ticket'),
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
      return const InputDecorator(
        decoration: InputDecoration(labelText: 'Assign to'),
        child: Row(children: [SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 12), Text('Loading users...')]),
      );
    }
    return InputDecorator(
      decoration: const InputDecoration(labelText: 'Assign Technicians', prefixIcon: Icon(Icons.group_add_outlined)),
      child: InkWell(
        onTap: _showMultiSelectDialog,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _assignedUsers.isEmpty
              ? Text('Select one or more technicians', style: TextStyle(color: Theme.of(context).hintColor))
              : Wrap(
            spacing: 6.0, runSpacing: 6.0,
            children: _assignedUsers.map((user) => Chip(label: Text(user.fullName), onDeleted: () => setState(() => _assignedUsers.remove(user)))).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _showMultiSelectDialog() async {
    final List<BoitexUser>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MultiSelectDialog(items: _assignableUsers, initialSelectedItems: _assignedUsers);
      },
    );
    if (results != null) {
      setState(() => _assignedUsers = results);
    }
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  Widget _text(String label, TextEditingController c, {String? Function(String?)? validator, int lines = 1}) {
    return TextFormField(
      controller: c,
      validator: validator,
      maxLines: lines,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _dateField(String label, DateTime? value, ValueChanged<DateTime?> onChanged) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(now.year - 3),
          lastDate: DateTime(now.year + 3),
          initialDate: value ?? now,
        );
        onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(value == null ? 'Pick a date' : DateFormat.yMMMd().format(value)),
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
        TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
        FilledButton(child: const Text('Done'), onPressed: () => Navigator.of(context).pop(_selectedItems)),
      ],
    );
  }
}