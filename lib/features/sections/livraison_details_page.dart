// lib/features/sections/livraison_details_page.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:boitex_info/features/sections/proof_of_delivery_page.dart';
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:boitex_info/features/sections/livraison_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';

class LivraisonDetailsPage extends StatefulWidget {
  final DeliveryNote note;
  final BoitexUser currentUser;
  const LivraisonDetailsPage({super.key, required this.note, required this.currentUser});

  @override
  State<LivraisonDetailsPage> createState() => _LivraisonDetailsPageState();
}

class _LivraisonDetailsPageState extends State<LivraisonDetailsPage> {
  bool _isSaving = false;
  final LivraisonService _service = LivraisonService();

  Future<void> _updateStatus(DeliveryStatus newStatus) async {
    setState(() => _isSaving = true);
    try {
      await _service.updateLivraisonStatus(widget.note, newStatus, widget.currentUser.fullName);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status Updated!'), backgroundColor: Colors.green));
        Navigator.pop(context, true); // Pop and signal a refresh
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _captureProofOfDelivery() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ProofOfDeliveryPage()),
    );

    if (result != null && mounted) {
      setState(() => _isSaving = true);
      try {
        final Uint8List? signature = result['signature'];
        final File? photoFile = result['photo'];
        String? photoBase64;

        if (signature == null) throw Exception('Signature is required.');

        if (photoFile != null) {
          final compressedBytes = await FlutterImageCompress.compressWithFile(photoFile.absolute.path, quality: 35);
          if (compressedBytes != null) {
            photoBase64 = base64Encode(compressedBytes);
          }
        }

        await _service.completeDelivery(
          noteId: widget.note.id!,
          noteCode: widget.note.code,
          clientName: widget.note.client,
          userName: widget.currentUser.fullName,
          signatureBase64: base64Encode(signature),
          photoBase64: photoBase64,
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery Completed!'), backgroundColor: Colors.green));
        Navigator.pop(context, true);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      } finally {
        if(mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Delivery: ${widget.note.code}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStatusTimeline(widget.note.status),
          const SizedBox(height: 24),
          _buildSection(context, 'Client Details', [
            _kv('Client', widget.note.client),
            _kv('Location', widget.note.location),
            _kv('Phone', widget.note.phone.isEmpty ? 'N/A' : widget.note.phone),
          ]),
          const SizedBox(height: 16),
          _buildSection(context, 'Articles', [
            for (var line in widget.note.lines)
              _kv(line.article, 'Qty: ${line.qty}'),
          ]),
          if (widget.note.isCompleted) ...[
            const SizedBox(height: 16),
            _buildSection(context, 'Proof of Delivery', [
              if (widget.note.clientSignaturePng != null)
                _signatureView('Client Signature', widget.note.clientSignaturePng!),
              if (widget.note.photoPng != null) ...[
                const SizedBox(height: 16),
                _photoView('Package Photo', widget.note.photoPng!),
              ]
            ]),
          ]
        ],
      ),
      bottomNavigationBar: _buildActionButton(),
    );
  }

  Widget _buildActionButton() {
    if (_isSaving) {
      return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
    }
    if (widget.note.status == DeliveryStatus.pending) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton.icon(
          icon: const Icon(Icons.local_shipping_outlined),
          label: const Text('Start Delivery'),
          onPressed: () => _updateStatus(DeliveryStatus.inTransit),
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      );
    }
    if (widget.note.status == DeliveryStatus.inTransit) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: FilledButton.icon(
          icon: const Icon(Icons.task_alt_outlined),
          label: const Text('Mark as Delivered'),
          onPressed: _captureProofOfDelivery,
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(key, style: TextStyle(color: Colors.grey.shade600)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _signatureView(String title, Uint8List signatureBytes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Image.memory(signatureBytes),
        ),
      ],
    );
  }

  Widget _photoView(String title, Uint8List photoBytes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(photoBytes, fit: BoxFit.cover, height: 200, width: double.infinity),
        ),
      ],
    );
  }

  Widget _buildStatusTimeline(DeliveryStatus currentStatus) {
    final statuses = [DeliveryStatus.pending, DeliveryStatus.inTransit, DeliveryStatus.delivered];
    final currentIndex = statuses.indexOf(currentStatus);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            for (var i = 0; i < statuses.length; i++) ...[
              Column(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: i <= currentIndex ? Colors.green : Colors.grey.shade300,
                    child: i < currentIndex ? const Icon(Icons.check, color: Colors.white, size: 20) : Text('${i+1}', style: TextStyle(color: i <= currentIndex ? Colors.white : Colors.grey)),
                  ),
                  const SizedBox(height: 4),
                  Text(statuses[i].name, style: TextStyle(fontSize: 10, color: i <= currentIndex ? Colors.black : Colors.grey)),
                ],
              ),
              if (i < statuses.length - 1)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Divider(
                      thickness: 2,
                      color: i < currentIndex ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}