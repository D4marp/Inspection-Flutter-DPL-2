import 'package:flutter/material.dart';

import '../controllers/inspection_controller.dart';
import '../models/inspection.dart';
import '../validation.dart';

class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({super.key, required this.controller});
  final InspectionController controller;

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  final _key = GlobalKey<FormState>();
  final _asset = TextEditingController();
  final _location = TextEditingController();
  final _note = TextEditingController();
  InspectionCondition _condition = InspectionCondition.good;

  @override
  void dispose() {
    _asset.dispose();
    _location.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_key.currentState?.validate() ?? false)) return;
    final result = await widget.controller.create({
      'assetCode': _asset.text.trim(),
      'location': _location.text.trim(),
      'condition': _condition.value,
      'note': _note.text.trim(),
    });
    if (mounted && result != null) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(title: const Text('Tambah inspeksi')),
      body: SafeArea(
        child: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              TextFormField(
                controller: _asset,
                maxLength: 30,
                decoration: const InputDecoration(labelText: 'Kode aset'),
                validator: (value) => validateRequired(value, 'Kode aset'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _location,
                maxLength: 80,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator: (value) => validateRequired(value, 'Lokasi'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<InspectionCondition>(
                initialValue: _condition,
                decoration: const InputDecoration(labelText: 'Kondisi'),
                items: InspectionCondition.values
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.label),
                      ),
                    )
                    .toList(),
                onChanged: widget.controller.isSubmitting
                    ? null
                    : (value) =>
                          setState(() => _condition = value ?? _condition),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _note,
                minLines: 3,
                maxLines: 5,
                maxLength: 500,
                decoration: const InputDecoration(labelText: 'Catatan'),
                validator: (value) => validateNote(
                  _condition == InspectionCondition.needsAction,
                  value,
                ),
              ),
              if (widget.controller.errorMessage != null)
                Text(
                  widget.controller.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: widget.controller.isSubmitting ? null : _save,
                icon: widget.controller.isSubmitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload_outlined),
                label: Text(
                  widget.controller.isSubmitting
                      ? 'Menyimpan…'
                      : 'Simpan ke API',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
