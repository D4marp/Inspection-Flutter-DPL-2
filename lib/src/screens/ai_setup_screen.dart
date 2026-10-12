import 'package:flutter/material.dart';

class AiSetupScreen extends StatelessWidget {
  const AiSetupScreen({super.key});

  static const _steps = [
    (
      '1',
      'Install OpenCode',
      'Pilih installer resmi sesuai OS, lalu cek: opencode --version',
    ),
    (
      '2',
      'Hubungkan provider',
      'Jalankan OpenCode, ketik /connect, lalu masukkan API key di terminal.',
    ),
    (
      '3',
      'Pilih model',
      'Gunakan /models dan pilih model yang diizinkan untuk training.',
    ),
    (
      '4',
      'Buka project',
      'Jalankan dari root repository agar context dan aturan project terbaca.',
    ),
  ];

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
    children: [
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xff102e33),
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OPENCODE · AI SETUP',
              style: TextStyle(
                color: Color(0xffe1ab4a),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'API key tinggal di tool developer, bukan di aplikasi Flutter.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Integrasi AI runtime berada di luar scope kelas dan memerlukan arsitektur tepercaya dengan auth, quota, dan audit.',
              style: TextStyle(color: Color(0xffc5d8d5), height: 1.45),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      ..._steps.map(
        (step) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xffdcebe8),
                  foregroundColor: const Color(0xff0b5f59),
                  child: Text(step.$1),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.$2,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(step.$3),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      const Card(
        color: Color(0xfffff7e7),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.key_off_outlined, color: Color(0xffa6670a)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Jangan menaruh API key pada source, .env yang di-commit, dart-define, asset, screenshot, atau log. Secret di client dapat diekstrak dari APK/IPA.',
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 18),
      const _CommandCard(
        title: 'Checkpoint terminal',
        command: 'opencode --version\n# di dalam TUI\n/connect\n/models',
      ),
    ],
  );
}

class _CommandCard extends StatelessWidget {
  const _CommandCard({required this.title, required this.command});
  final String title;
  final String command;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xff092f35),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(
          command,
          style: const TextStyle(
            color: Color(0xffcfe0dd),
            fontFamily: 'monospace',
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
