import 'package:flutter/material.dart';
import '../features/common/ui/safe_headers.dart';

class DemoRequestFormPage extends StatelessWidget {
  const DemoRequestFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    const nextCode = 'INT42';
    return Scaffold(
      appBar: AppBar(title: buildSafeAppBarTitle('New Request (Demo)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RequestHeader(
                  icon: Icons.add_circle_outline,
                  title: 'Request New Intervention',
                  codeText: 'Code: $nextCode',
                  tint: const Color(0xFF00BCD4),
                ),
                const SizedBox(height: 16),
                TextFormField(decoration: const InputDecoration(labelText: 'Client / Store Name')),
                const SizedBox(height: 12),
                TextFormField(decoration: const InputDecoration(labelText: 'Store Location')),
                const SizedBox(height: 12),
                TextFormField(decoration: const InputDecoration(labelText: 'Phone')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}