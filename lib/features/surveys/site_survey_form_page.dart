// lib/features/surveys/site_survey_form_page.dart
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/features/surveys/site_survey.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Helper class to manage controllers for each entrance
class _EntranceController {
  final TextEditingController width = TextEditingController();
  EntranceType type = EntranceType.noDoor;

  void dispose() {
    width.dispose();
  }
}

class SiteSurveyFormPage extends StatefulWidget {
  final BoitexUser currentUser;
  const SiteSurveyFormPage({super.key, required this.currentUser});

  @override
  State<SiteSurveyFormPage> createState() => _SiteSurveyFormPageState();
}

class _SiteSurveyFormPageState extends State<SiteSurveyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientName = TextEditingController();
  final _storeLocation = TextEditingController();
  final _clientNeeds = TextEditingController();

  final List<_EntranceController> _entranceControllers = [_EntranceController()];
  bool _isPowerAvailable = false;
  bool _hasUndergroundTube = false;
  bool _canCutFloor = false;
  bool _saving = false;

  @override
  void dispose() {
    _clientName.dispose();
    _storeLocation.dispose();
    _clientNeeds.dispose();
    for (var controller in _entranceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSurvey() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    setState(() => _saving = true);

    final survey = SiteSurvey(
      clientName: _clientName.text.trim(),
      storeLocation: _storeLocation.text.trim(),
      surveyDate: DateTime.now(),
      surveyedByName: widget.currentUser.fullName,
      clientNeeds: _clientNeeds.text.trim(),
      isPowerAvailable: _isPowerAvailable,
      hasUndergroundTube: _hasUndergroundTube,
      canCutFloor: _canCutFloor,
      entrances: _entranceControllers.map((ctrl) {
        return {
          'width': double.tryParse(ctrl.width.text) ?? 0.0,
          'type': ctrl.type.name,
        };
      }).toList(),
    );

    try {
      await FirebaseFirestore.instance.collection('site_surveys').add(survey.toJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Site survey saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save survey: $e')),
        );
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
      appBar: AppBar(
        title: const Text('New Site Survey'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Client Information'),
              TextFormField(
                controller: _clientName,
                decoration: const InputDecoration(labelText: 'Client Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _storeLocation,
                decoration: const InputDecoration(labelText: 'Store Location'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientNeeds,
                decoration: const InputDecoration(labelText: 'Client Needs / Requirements'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Entrances'),
              ..._buildEntranceFields(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Entrance'),
                  onPressed: () {
                    setState(() {
                      _entranceControllers.add(_EntranceController());
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Technical Details'),
              SwitchListTile(
                title: const Text('Is 220V power source near the entrance?'),
                value: _isPowerAvailable,
                onChanged: (val) => setState(() => _isPowerAvailable = val),
              ),
              SwitchListTile(
                title: const Text('Is there an empty underground tube for cables?'),
                value: _hasUndergroundTube,
                onChanged: (val) => setState(() => _hasUndergroundTube = val),
              ),
              SwitchListTile(
                title: const Text('Can the floor be cut to pass cables?'),
                subtitle: const Text('(If no tube is available)'),
                value: _canCutFloor,
                onChanged: (val) => setState(() => _canCutFloor = val),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _saving ? null : _saveSurvey,
                  icon: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save),
                  label: Text(_saving ? 'Saving...' : 'Save Survey'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }

  List<Widget> _buildEntranceFields() {
    return List.generate(_entranceControllers.length, (index) {
      final ctrl = _entranceControllers[index];
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Entrance #${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (_entranceControllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          ctrl.dispose();
                          _entranceControllers.removeAt(index);
                        });
                      },
                    ),
                ],
              ),
              TextFormField(
                controller: ctrl.width,
                decoration: const InputDecoration(labelText: 'Width (in meters)'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<EntranceType>(
                value: ctrl.type,
                decoration: const InputDecoration(labelText: 'Entrance Type'),
                items: const [
                  DropdownMenuItem(value: EntranceType.noDoor, child: Text('No Door')),
                  DropdownMenuItem(value: EntranceType.glassDoor, child: Text('Glass Door')),
                  DropdownMenuItem(value: EntranceType.autoGlassDoor, child: Text('Automatic Glass Door')),
                ],
                onChanged: (val) {
                  setState(() {
                    ctrl.type = val ?? EntranceType.noDoor;
                  });
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}