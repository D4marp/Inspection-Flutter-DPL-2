import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/inspection.dart';
import 'api_client.dart';

class InspectionResult {
  const InspectionResult({
    required this.items,
    required this.isCached,
    required this.fetchedAt,
  });
  final List<Inspection> items;
  final bool isCached;
  final DateTime fetchedAt;
}

class InspectionRepository {
  InspectionRepository(this.api, {SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final ApiClient api;
  final SharedPreferencesAsync _preferences;
  static const _cacheKey = 'inspection_cache_v1';

  Future<InspectionResult> list() async {
    try {
      final items = await api.fetchInspections();
      final result = InspectionResult(
        items: items,
        isCached: false,
        fetchedAt: DateTime.now().toUtc(),
      );
      await _writeCache(result);
      return result;
    } on TimeoutException {
      return (await _readCache()) ??
          (throw const ApiException(408, 'Request timeout dan cache kosong.'));
    } on SocketException {
      return (await _readCache()) ??
          (throw const ApiException(
            503,
            'Tidak dapat terhubung dan cache kosong.',
          ));
    } on http.ClientException {
      return (await _readCache()) ??
          (throw const ApiException(503, 'Koneksi gagal dan cache kosong.'));
    } on ApiException catch (error) {
      if (error.statusCode == 401) await clearSession();
      rethrow;
    }
  }

  Future<Inspection> create(Map<String, dynamic> fields) async {
    try {
      return await api.createInspection(fields);
    } on ApiException catch (error) {
      if (error.statusCode == 401) await clearSession();
      rethrow;
    }
  }

  Future<void> clearSession() async {
    await api.clearToken();
    await _preferences.remove(_cacheKey);
  }

  Future<void> _writeCache(InspectionResult result) async {
    try {
      await _preferences.setString(
        _cacheKey,
        jsonEncode({
          'fetchedAt': result.fetchedAt.toIso8601String(),
          'items': result.items.map((item) => item.toJson()).toList(),
        }),
      );
    } on Object {
      // API success tetap ditampilkan meskipun cache gagal ditulis.
    }
  }

  Future<InspectionResult?> _readCache() async {
    final raw = await _preferences.getString(_cacheKey);
    if (raw == null) return null;
    try {
      final body = jsonDecode(raw) as Map<String, dynamic>;
      final items = (body['items'] as List<dynamic>)
          .map((item) => Inspection.fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
      return InspectionResult(
        items: items,
        isCached: true,
        fetchedAt: DateTime.parse(body['fetchedAt'] as String).toUtc(),
      );
    } on Object {
      await _preferences.remove(_cacheKey);
      return null;
    }
  }
}
