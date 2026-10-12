import 'dart:async';

import 'package:http/http.dart' as http;

import '../json_response_decoder.dart';

class DeleteInspection {
  const DeleteInspection({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<void> call(String id) async {
    final response = await client
        .delete(Uri.parse('$baseUrl/posts/$id'))
        .timeout(const Duration(seconds: 10));
    JsonResponseDecoder.empty(response, expectedStatuses: const {200, 204});
  }
}
