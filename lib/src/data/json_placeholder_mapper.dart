import '../models/inspection.dart';

/// Adapter antara resource `/posts` milik JSONPlaceholder dan model latihan.
///
/// [ApiClient] menangani HTTP, sedangkan mapper menangani perbedaan schema API
/// publik dengan bahasa domain aplikasi.
abstract final class JsonPlaceholderMapper {
  static Inspection fromPost(Map<String, dynamic> json) {
    final id = json['id'].toString();
    final numericId = int.tryParse(id) ?? 0;
    final rawCondition = json['condition'];

    return Inspection(
      id: id,
      assetCode:
          json['assetCode'] as String? ??
          'POST-${numericId.toString().padLeft(3, '0')}',
      location: json['location'] as String? ?? 'User ${json['userId'] ?? '-'}',
      condition: rawCondition is String
          ? InspectionConditionX.parse(rawCondition)
          : numericId.isEven
          ? InspectionCondition.good
          : InspectionCondition.needsAction,
      note: (json['note'] ?? json['body'] ?? '').toString(),
      createdAt: _createdAt(json['createdAt'], numericId),
    );
  }

  static Map<String, dynamic> toPost(
    Map<String, dynamic> fields, {
    String? id,
  }) {
    final numericId = id == null ? null : int.tryParse(id);
    final result = <String, dynamic>{
      'userId': 1,
      'title': fields['assetCode'],
      'body': fields['note'],
      ...fields,
    };
    if (numericId != null) result['id'] = numericId;
    return result;
  }

  static DateTime _createdAt(Object? value, int id) {
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed.toUtc();
    }
    return DateTime.utc(2026).add(Duration(days: id.clamp(0, 365)));
  }
}
