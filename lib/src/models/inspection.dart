enum InspectionCondition { good, needsAction }

extension InspectionConditionX on InspectionCondition {
  String get value =>
      this == InspectionCondition.good ? 'good' : 'needs_action';
  String get label =>
      this == InspectionCondition.good ? 'Baik' : 'Perlu tindak lanjut';

  static InspectionCondition parse(String raw) => switch (raw) {
    'good' => InspectionCondition.good,
    'needs_action' => InspectionCondition.needsAction,
    _ => throw FormatException('Kondisi inspeksi tidak dikenal: $raw'),
  };
}

class Inspection {
  const Inspection({
    required this.id,
    required this.assetCode,
    required this.location,
    required this.condition,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final String assetCode;
  final String location;
  final InspectionCondition condition;
  final String note;
  final DateTime createdAt;

  factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
    id: json['id'] as String,
    assetCode: json['assetCode'] as String,
    location: json['location'] as String,
    condition: InspectionConditionX.parse(json['condition'] as String),
    note: (json['note'] as String?) ?? '',
    createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'assetCode': assetCode,
    'location': location,
    'condition': condition.value,
    'note': note,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };
}
