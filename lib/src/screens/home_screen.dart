import 'package:flutter/material.dart';

import '../controllers/inspection_controller.dart';
import '../data/inspection_repository.dart';
import '../models/inspection.dart';
import 'ai_setup_screen.dart';
import 'inspection_detail_screen.dart';
import 'inspection_form_screen.dart';
import 'ui_foundation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});
  final InspectionRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final InspectionController _controller;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _controller = InspectionController(widget.repository)..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openForm([Inspection? item]) async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            InspectionFormScreen(controller: _controller, initialItem: item),
      ),
    );
    if (!mounted || created != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item == null
              ? 'Create simulasi berhasil — reset akan menghapus perubahan'
              : 'Update simulasi berhasil — reset mengembalikan data publik',
        ),
      ),
    );
  }

  Future<void> _delete(Inspection item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus inspeksi?'),
        content: Text('${item.assetCode} akan dihapus dari API training.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted = await _controller.delete(item.id);
    if (!mounted || !deleted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item.assetCode} dihapus dari UI — reset mengembalikan data publik',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(switch (_tab) {
              0 => 'CRUD JSONPlaceholder',
              1 => 'Flutter UI Foundations',
              _ => 'OpenCode & AI Setup',
            }, style: const TextStyle(fontWeight: FontWeight.w700)),
            const Text(
              'DPL Flutter · Hari 2',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          if (_tab == 0)
            IconButton(
              onPressed: _controller.isLoading ? null : _controller.load,
              icon: const Icon(Icons.refresh),
              tooltip: 'Muat ulang',
            ),
          const Padding(
            padding: EdgeInsets.only(right: 14),
            child: Center(
              child: Text(
                'PUBLIC DEMO',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (_tab) {
          0 => _body(),
          1 => const UiFoundationScreen(),
          _ => const AiSetupScreen(),
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'CRUD API',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets),
            label: 'UI Dasar',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI Setup',
          ),
        ],
      ),
      floatingActionButton:
          _tab != 0 || _controller.isLoading || _controller.isCached
          ? null
          : FloatingActionButton.extended(
              onPressed: _openForm,
              icon: const Icon(Icons.add),
              label: const Text('Create'),
            ),
    ),
  );

  Widget _body() {
    if (_controller.isLoading && _controller.items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Mengambil data API…'),
          ],
        ),
      );
    }
    if (_controller.errorMessage != null && _controller.items.isEmpty) {
      return _MessageState(
        icon: Icons.cloud_off,
        title: 'Data gagal dimuat',
        message: _controller.errorMessage!,
        action: FilledButton(
          onPressed: _controller.load,
          child: const Text('Coba lagi'),
        ),
      );
    }
    if (_controller.items.isEmpty) {
      return _MessageState(
        icon: Icons.assignment_outlined,
        title: 'Belum ada inspeksi',
        message: 'Server aktif, tetapi belum mempunyai data.',
        action: FilledButton(
          onPressed: _openForm,
          child: const Text('Tambah inspeksi'),
        ),
      );
    }
    return Column(
      children: [
        MaterialBanner(
          leading: const Icon(Icons.science_outlined),
          content: const Text(
            'JSONPlaceholder adalah API publik simulasi. Create, update, dan '
            'delete hanya berubah di UI sampai data dimuat ulang.',
          ),
          actions: [
            TextButton(onPressed: _controller.load, child: const Text('RESET')),
          ],
        ),
        if (_controller.isCached)
          MaterialBanner(
            content: const Text(
              'Mode offline: menampilkan cache. Create dinonaktifkan.',
            ),
            actions: [
              TextButton(
                onPressed: _controller.load,
                child: const Text('COBA LAGI'),
              ),
            ],
          ),
        if (_controller.errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              _controller.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _controller.load,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              itemCount: _controller.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = _controller.items[index];
                return Card(
                  child: ListTile(
                    key: ValueKey(item.id),
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: Icon(
                        item.condition == InspectionCondition.good
                            ? Icons.check
                            : Icons.warning_amber,
                      ),
                    ),
                    title: Text(
                      item.assetCode,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${item.location}\n${item.condition.label}'),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      tooltip: 'Aksi CRUD',
                      onSelected: (value) {
                        if (value == 'edit') _openForm(item);
                        if (value == 'delete') _delete(item);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Update'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => InspectionDetailScreen(item: item),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          action,
        ],
      ),
    ),
  );
}
