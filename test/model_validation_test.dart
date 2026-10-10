import 'package:dpl_inspection_day_2/src/models/inspection.dart';
import 'package:dpl_inspection_day_2/src/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('inspection JSON round trip preserves fields', () {
    final source = {
      'id': '1',
      'assetCode': 'PMP-001',
      'location': 'Workshop A',
      'condition': 'good',
      'note': '',
      'createdAt': '2026-10-03T01:00:00Z',
    };
    final item = Inspection.fromJson(source);
    expect(item.condition, InspectionCondition.good);
    expect(Inspection.fromJson(item.toJson()).assetCode, 'PMP-001');
  });

  test('invalid condition is rejected', () {
    expect(() => InspectionConditionX.parse('unknown'), throwsFormatException);
  });

  test('needs action requires descriptive note', () {
    expect(validateNote(true, 'cek'), isNotNull);
    expect(validateNote(true, 'Getaran motor tinggi'), isNull);
  });
}
