import 'dart:async';

import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../json_response_decoder.dart';

class DeleteInspection {
  const DeleteInspection({required this.client, required this.endpoints});

  final http.Client client;
  final ApiEndpoints endpoints;

  Future<void> call(String id) async {
    final response = await client
        .delete(endpoints.item(id))
        .timeout(endpoints.timeout);
    JsonResponseDecoder.empty(response, expectedStatuses: const {200, 204});
  }
}
