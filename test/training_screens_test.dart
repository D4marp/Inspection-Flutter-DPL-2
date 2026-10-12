import 'package:dpl_inspection_day_2/src/screens/ai_setup_screen.dart';
import 'package:dpl_inspection_day_2/src/screens/ui_foundation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UI foundation validates the example form', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UiFoundationScreen())),
    );

    expect(find.text('Scaffold'), findsOneWidget);
    expect(find.text('Row'), findsOneWidget);
    expect(find.text('Column'), findsOneWidget);

    await tester.tap(find.text('Validasi'));
    await tester.pump();
    expect(find.text('Wajib diisi'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'InspectionCard');
    await tester.tap(find.text('Validasi'));
    await tester.pump();
    expect(find.text('Valid: InspectionCard'), findsOneWidget);
  });

  testWidgets('AI setup teaches secret boundaries', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: AiSetupScreen())),
    );

    expect(find.text('OPENCODE · AI SETUP'), findsOneWidget);
    expect(find.textContaining('bukan di aplikasi Flutter'), findsOneWidget);
    expect(find.text('Install OpenCode'), findsOneWidget);
    expect(find.text('Hubungkan provider'), findsOneWidget);
  });
}
