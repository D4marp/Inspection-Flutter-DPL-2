import 'package:flutter/material.dart';

import '../models/inspection.dart';

class InspectionDetailScreen extends StatelessWidget {
  const InspectionDetailScreen({super.key, required this.item});
  final Inspection item;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detail inspeksi')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            item.assetCode,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Chip(
            avatar: Icon(
              item.condition == InspectionCondition.good
                  ? Icons.check_circle
                  : Icons.warning_amber,
            ),
            label: Text(item.condition.label),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text('Lokasi'),
            subtitle: Text(item.location),
          ),
          ListTile(
            leading: const Icon(Icons.notes_outlined),
            title: const Text('Catatan'),
            subtitle: Text(item.note.isEmpty ? 'Tanpa catatan' : item.note),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Waktu'),
            subtitle: Text(item.createdAt.toLocal().toString()),
          ),
          ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('ID server'),
            subtitle: Text(item.id),
          ),
        ],
      ),
    ),
  );
}
