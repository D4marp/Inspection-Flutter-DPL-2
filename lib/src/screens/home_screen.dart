import 'package:flutter/material.dart';

import '../controllers/inspection_controller.dart';
import '../controllers/session_controller.dart';
import '../data/inspection_repository.dart';
import '../models/inspection.dart';
import 'inspection_detail_screen.dart';
import 'inspection_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.session,
    required this.repository,
  });
  final SessionController session;
  final InspectionRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final InspectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InspectionController(
      widget.repository,
      onSessionExpired: widget.session.expire,
    )..load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => InspectionFormScreen(controller: _controller),
      ),
    );
    if (!mounted || created != true) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Inspeksi tersimpan di server')),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) => Scaffold(
      appBar: AppBar(
        title: const Text('DPL Inspection'),
        actions: [
          IconButton(
            onPressed: _controller.isLoading ? null : _controller.load,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
          IconButton(
            onPressed: widget.session.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: SafeArea(child: _body()),
      floatingActionButton: _controller.isLoading || _controller.isCached
          ? null
          : FloatingActionButton.extended(
              onPressed: _create,
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
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
          onPressed: _create,
          child: const Text('Tambah inspeksi'),
        ),
      );
    }
    return Column(
      children: [
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
                    trailing: const Icon(Icons.chevron_right),
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
