import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

abstract final class JsonResponseDecoder {
  static List<Map<String, dynamic>> list(
    http.Response response, {
    required int expectedStatus,
  }) {
    _ensureStatus(response, expectedStatus);
    try {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((item) => item as Map<String, dynamic>)
          .toList(growable: false);
    } on Object {
      throw const ApiException(502, 'Format list JSONPlaceholder tidak valid.');
    }
  }

  static Map<String, dynamic> object(
    http.Response response, {
    required int expectedStatus,
  }) {
    _ensureStatus(response, expectedStatus);
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } on Object {
      throw const ApiException(
        502,
        'Format object JSONPlaceholder tidak valid.',
      );
    }
  }

  static void empty(
    http.Response response, {
    required Set<int> expectedStatuses,
  }) {
    if (!expectedStatuses.contains(response.statusCode)) {
      _throwApiError(response);
    }
  }

  static void _ensureStatus(http.Response response, int expectedStatus) {
    if (response.statusCode != expectedStatus) _throwApiError(response);
  }

  static Never _throwApiError(http.Response response) {
    var message = 'Request JSONPlaceholder gagal (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body['message'] is String) {
        message = body['message'] as String;
      }
    } on FormatException {
      // Pertahankan pesan HTTP ketika body bukan JSON.
    }
    throw ApiException(response.statusCode, message);
  }
}
