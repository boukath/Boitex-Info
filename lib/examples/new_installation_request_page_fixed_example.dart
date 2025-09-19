import 'package:flutter/material.dart';
import '../features/common/ui/safe_headers.dart';

class NewInstallationRequestPageExample extends StatelessWidget {
  const NewInstallationRequestPageExample({super.key});

  @override
  Widget build(BuildContext context) {
    final nextCode = 'INS3'; // sample

    return Scaffold(
      appBar: AppBar(
        title: buildSafeAppBarTitle('New Installation Request'),
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
                  title: 'Request New Installation',
                  codeText: 'Code: INS3',
                  tint: Color(0xFF7C4DFF),
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