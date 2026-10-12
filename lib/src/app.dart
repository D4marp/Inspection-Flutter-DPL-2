import 'package:flutter/material.dart';

import 'data/api_client.dart';
import 'data/inspection_repository.dart';
import 'screens/home_screen.dart';

const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://jsonplaceholder.typicode.com',
);

class DplInspectionApp extends StatefulWidget {
  const DplInspectionApp({super.key});

  @override
  State<DplInspectionApp> createState() => _DplInspectionAppState();
}

class _DplInspectionAppState extends State<DplInspectionApp> {
  late final ApiClient _api;
  late final InspectionRepository _repository;

  @override
  void initState() {
    super.initState();
    _api = ApiClient(baseUrl: apiBaseUrl);
    _repository = InspectionRepository(_api);
  }

  @override
  void dispose() {
    _api.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'DPL Inspection',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff0b5f59),
        primary: const Color(0xff0b5f59),
        secondary: const Color(0xffd79b32),
        surface: const Color(0xfff8faf9),
      ),
      scaffoldBackgroundColor: const Color(0xfff3f6f5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff092f35),
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: Color(0xffdfe7e5)),
        ),
      ),
      useMaterial3: true,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    ),
    home: HomeScreen(repository: _repository),
  );
}
