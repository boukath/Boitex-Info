// lib/features/sections/proof_of_delivery_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class ProofOfDeliveryPage extends StatefulWidget {
  const ProofOfDeliveryPage({super.key});

  @override
  State<ProofOfDeliveryPage> createState() => _ProofOfDeliveryPageState();
}

class _ProofOfDeliveryPageState extends State<ProofOfDeliveryPage> {
  final _signatureController = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  void _confirmDelivery() async {
    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Client signature is required.'), backgroundColor: Colors.red));
      return;
    }
    final signatureBytes = await _signatureController.toPngBytes();
    Navigator.pop(context, {'signature': signatureBytes, 'photo': _image});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proof of Delivery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Client Signature', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(controller: _signatureController, backgroundColor: Colors.white),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => _signatureController.clear(), child: const Text('Clear')),
            ),
            const SizedBox(height: 24),
            Text('Photo of Delivered Item (Optional)', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: _image == null
                    ? const Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Tap to take photo'),
                  ]),
                )
                    : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(_image!, fit: BoxFit.cover)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: _confirmDelivery,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirm Delivery'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}