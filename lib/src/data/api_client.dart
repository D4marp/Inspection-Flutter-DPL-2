import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/inspection.dart';

class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);
  final int statusCode;
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    FlutterSecureStorage? secureStorage,
  }) : _http = httpClient ?? http.Client(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null ||
        !uri.hasAuthority ||
        !{'http', 'https'}.contains(uri.scheme)) {
      throw ArgumentError.value(baseUrl, 'baseUrl', 'URL API tidak valid');
    }
  }

  final String baseUrl;
  final http.Client _http;
  final FlutterSecureStorage _secureStorage;
  static const _tokenKey = 'session_token';

  Future<String?> readToken() => _secureStorage.read(key: _tokenKey);
  Future<void> clearToken() => _secureStorage.delete(key: _tokenKey);

  Future<void> login(String username, String password) async {
    final response = await _http
        .post(
          Uri.parse('$baseUrl/auth/login'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'username': username, 'password': password}),
        )
        .timeout(const Duration(seconds: 10));
    final body = _decode(response, 200);
    await _secureStorage.write(key: _tokenKey, value: body['token'] as String);
  }

  Future<List<Inspection>> fetchInspections() async {
    final response = await _http
        .get(
          Uri.parse('$baseUrl/inspections?per_page=50'),
          headers: await _authHeaders(),
        )
        .timeout(const Duration(seconds: 10));
    final body = _decode(response, 200);
    return (body['items'] as List<dynamic>)
        .map((item) => Inspection.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<Inspection> createInspection(Map<String, dynamic> fields) async {
    final response = await _http
        .post(
          Uri.parse('$baseUrl/inspections'),
          headers: await _authHeaders(),
          body: jsonEncode(fields),
        )
        .timeout(const Duration(seconds: 10));
    return Inspection.fromJson(_decode(response, 201));
  }

  Future<Map<String, String>> _authHeaders() async {
    final token = await readToken();
    if (token == null || token.isEmpty) {
      throw const ApiException(401, 'Silakan login kembali.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Map<String, dynamic> _decode(http.Response response, int expectedStatus) {
    if (response.statusCode != expectedStatus) {
      var message = 'Request gagal (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic> && body['message'] is String) {
          message = body['message'] as String;
        }
      } on FormatException {
        // Pertahankan error HTTP bila payload error bukan JSON.
      }
      throw ApiException(response.statusCode, message);
    }
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on Object {
      throw const ApiException(502, 'Format respons server tidak valid.');
    }
  }

  void close() => _http.close();
}
