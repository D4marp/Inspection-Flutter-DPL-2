import 'package:flutter/material.dart';

import 'controllers/session_controller.dart';
import 'data/api_client.dart';
import 'data/inspection_repository.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);
const autoLogin = bool.fromEnvironment('AUTO_LOGIN');

class DplInspectionApp extends StatefulWidget {
  const DplInspectionApp({super.key});

  @override
  State<DplInspectionApp> createState() => _DplInspectionAppState();
}

class _DplInspectionAppState extends State<DplInspectionApp> {
  late final ApiClient _api;
  late final InspectionRepository _repository;
  late final SessionController _session;

  @override
  void initState() {
    super.initState();
    _api = ApiClient(baseUrl: apiBaseUrl);
    _repository = InspectionRepository(_api);
    _session = SessionController(_api, _repository)
      ..initialize(autoLogin: autoLogin);
  }

  @override
  void dispose() {
    _session.dispose();
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DPL Inspection',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff006a60)),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: ListenableBuilder(
      listenable: _session,
      builder: (context, _) => switch (_session.status) {
        SessionStatus.starting => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        SessionStatus.signedOut => LoginScreen(session: _session),
        SessionStatus.signedIn => HomeScreen(
          session: _session,
          repository: _repository,
        ),
      },
    ),
  );
}
