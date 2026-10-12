import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/inspection_controller.dart';
import '../models/inspection.dart';
import '../validation.dart';

class InspectionFormScreen extends StatefulWidget {
  const InspectionFormScreen({
    super.key,
    required this.controller,
    this.initialItem,
  });
  final InspectionController controller;
  final Inspection? initialItem;

  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  final _key = GlobalKey<FormState>();
  final _asset = TextEditingController();
  final _location = TextEditingController();
  final _note = TextEditingController();
  InspectionCondition _condition = InspectionCondition.good;
  XFile? _image;
  PlatformFile? _file;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    if (item == null) return;
    _asset.text = item.assetCode;
    _location.text = item.location;
    _note.text = item.note;
    _condition = item.condition;
  }

  @override
  void dispose() {
    _asset.dispose();
    _location.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_key.currentState?.validate() ?? false)) return;
    final fields = {
      'assetCode': _asset.text.trim(),
      'location': _location.text.trim(),
      'condition': _condition.value,
      'note': _note.text.trim(),
    };
    final result = _isEditing
        ? await widget.controller.update(widget.initialItem!.id, fields)
        : await widget.controller.create(fields);
    if (mounted && result != null) Navigator.of(context).pop(true);
  }

  Future<void> _pickImage() async {
    final selected = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 82,
    );
    if (!mounted || selected == null) return;
    setState(() {
      _image = selected;
      _file = null;
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFile();
    if (!mounted || result == null) return;
    setState(() {
      _file = result;
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Update inspeksi' : 'Create inspeksi'),
      ),
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
              const SizedBox(height: 14),
              _AttachmentPanel(
                image: _image,
                file: _file,
                onPickImage: widget.controller.isSubmitting ? null : _pickImage,
                onPickFile: widget.controller.isSubmitting ? null : _pickFile,
                onClear: widget.controller.isSubmitting
                    ? null
                    : () => setState(() {
                        _image = null;
                        _file = null;
                      }),
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
                      : _isEditing
                      ? 'Update melalui API'
                      : 'Create melalui API',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _AttachmentPanel extends StatelessWidget {
  const _AttachmentPanel({
    required this.image,
    required this.file,
    required this.onPickImage,
    required this.onPickFile,
    required this.onClear,
  });

  final XFile? image;
  final PlatformFile? file;
  final VoidCallback? onPickImage;
  final VoidCallback? onPickFile;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Card(
    color: const Color(0xfff4f8f7),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Lampiran lokal',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Latihan picker saja—file belum di-upload ke CRUD API.',
            style: TextStyle(fontSize: 12),
          ),
          if (image != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                File(image!.path),
                height: 170,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox(
                  height: 100,
                  child: Center(child: Text('Preview tidak tersedia')),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(image!.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
          if (file != null) ...[
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.description_outlined),
              ),
              title: Text(
                file!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                file!.lengthSync() == null
                    ? 'Ukuran tidak tersedia'
                    : '${(file!.lengthSync()! / 1024).ceil()} KB',
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: onPickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text('Pilih image'),
              ),
              OutlinedButton.icon(
                onPressed: onPickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text('Pilih file'),
              ),
              if (image != null || file != null)
                TextButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                  label: const Text('Hapus'),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
