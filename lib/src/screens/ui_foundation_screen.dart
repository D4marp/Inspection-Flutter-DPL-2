import 'package:flutter/material.dart';

class UiFoundationScreen extends StatefulWidget {
  const UiFoundationScreen({super.key});

  @override
  State<UiFoundationScreen> createState() => _UiFoundationScreenState();
}

class _UiFoundationScreenState extends State<UiFoundationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _result = 'Belum ada submit';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    children: [
      Text(
        'UI FOUNDATIONS',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xffa66d17),
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Scaffold mengatur halaman; Row dan Column menyusun konten.',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
      ),
      const SizedBox(height: 18),
      const Row(
        children: [
          Expanded(
            child: _ConceptCard(
              icon: Icons.web_asset_outlined,
              title: 'Scaffold',
              text: 'Struktur screen',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _ConceptCard(
              icon: Icons.view_column_outlined,
              title: 'Row',
              text: 'Arah horizontal',
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _ConceptCard(
              icon: Icons.view_agenda_outlined,
              title: 'Column',
              text: 'Arah vertikal',
            ),
          ),
        ],
      ),
      const SizedBox(height: 18),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Form + validation',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Nama komponen',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Wajib diisi'
                      : null,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) return;
                    setState(() => _result = 'Valid: ${_name.text.trim()}');
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Validasi'),
                ),
                const SizedBox(height: 10),
                Text(_result, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Card(
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Text(
            'Struktur halaman aktif tetap dapat dilihat pada source HomeScreen: Scaffold → AppBar + body + NavigationBar + FloatingActionButton.',
          ),
        ),
      ),
    ],
  );
}

class _ConceptCard extends StatelessWidget {
  const _ConceptCard({
    required this.icon,
    required this.title,
    required this.text,
  });
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
