import 'package:boitex_info/auth/models/boitex_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// FIX: Removed imports for AppBackground and GlassCard
import 'package:boitex_info/features/sections/livraison_domain.dart';
import 'package:boitex_info/features/sections/livraison_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewLivraisonPage extends StatefulWidget {
  final BoitexUser user;
  const NewLivraisonPage({super.key, required this.user});

  @override
  State<NewLivraisonPage> createState() => _NewLivraisonPageState();
}

class _NewLivraisonPageState extends State<NewLivraisonPage> {
  final _formKey = GlobalKey<FormState>();
  final LivraisonService _service = LivraisonService();
  final _client = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final List<_LineItemControllers> _lines = [_LineItemControllers()];

  String? _nextCode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNextCode();
  }

  Future<void> _fetchNextCode() async {
    final code = await _service.getNextCode();
    if (mounted) {
      setState(() {
        _nextCode = code;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _client.dispose();
    _phone.dispose();
    _location.dispose();
    for (var line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  Future<void> _saveSale() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final note = DeliveryNote(
        code: _nextCode!,
        client: _client.text.trim(),
        phone: _phone.text.trim(),
        location: _location.text.trim(),
        lines: _lines
            .where((l) => l.article.text.trim().isNotEmpty)
            .map((l) => DeliveryLine(
          article: l.article.text.trim(),
          qty: int.tryParse(l.qty.text.trim()) ?? 1,
          price: double.tryParse(l.price.text.trim()),
        ))
            .toList(),
        createdById: widget.user.uid,
        createdByName: widget.user.fullName,
        createdAt: Timestamp.now(),
      );
      final user = FirebaseAuth.instance.currentUser;
      final userName = user?.displayName ?? user?.email ?? 'System Action';

      try {
        await _service.addLivraison(note, userName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sale ${_nextCode} created successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error saving sale: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Replaced AppBackground with a standard Scaffold.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Sale / BL'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // FIX: Replaced GlassCard with a standard Card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_pin_circle_outlined),
                          const SizedBox(width: 12),
                          Text('Client Details',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          if (_nextCode != null) Chip(label: Text(_nextCode!))
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                          _client, 'Client Name*', Icons.person_outline),
                      const SizedBox(height: 16),
                      _buildTextField(
                          _phone, 'Phone Number', Icons.phone_outlined,
                          keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildTextField(_location, 'Location / Address',
                          Icons.location_on_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // FIX: Replaced GlassCard with a standard Card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.inventory_2_outlined),
                          const SizedBox(width: 12),
                          Text('Articles',
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._buildArticleLines(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Article'),
                          onPressed: () =>
                              setState(() => _lines.add(_LineItemControllers())),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.save_alt_rounded),
                  label: const Text('Save Sale'),
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _saveSale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildArticleLines() {
    return List.generate(_lines.length, (i) {
      final line = _lines[i];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        // FIX: Replaced GlassCard with a standard Card.
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 4,
                    child:
                    _buildTextField(line.article, 'Article Name*', null)),
                const SizedBox(width: 8),
                Expanded(
                    flex: 2,
                    child: _buildTextField(line.qty, 'Qty*', null,
                        keyboardType: TextInputType.number)),
                const SizedBox(width: 8),
                Expanded(
                    flex: 3,
                    child: _buildTextField(line.price, 'Price', null,
                        keyboardType: TextInputType.number)),
                if (_lines.length > 1)
                  IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.redAccent),
                      onPressed: () => setState(() => _lines.removeAt(i)))
                else
                  const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      );
    });
  }

  TextFormField _buildTextField(
      TextEditingController controller, String label, IconData? icon,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (v) =>
      (v == null || v.trim().isEmpty) && label.endsWith('*')
          ? 'Required'
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}

class _LineItemControllers {
  final article = TextEditingController();
  final qty = TextEditingController(text: '1');
  final price = TextEditingController();

  void dispose() {
    article.dispose();
    qty.dispose();
    price.dispose();
  }
}