import 'package:flutter/material.dart';
import '../features/common/ui/safe_headers.dart';

class NewInterventionRequestPageExample extends StatelessWidget {
  const NewInterventionRequestPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    final nextCode = 'INT5'; // sample

    return Scaffold(
      appBar: AppBar(
        title: buildSafeAppBarTitle('New Intervention Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RequestHeader(
                  icon: Icons.add_circle_outline,
                  title: 'Request New Intervention',
                  codeText: 'Code: INT5',
                  tint: Color(0xFF00BCD4),
                ),
                const SizedBox(height: 16),
                // … your form fields here
                TextFormField(decoration: const InputDecoration(labelText: 'Client Name')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}