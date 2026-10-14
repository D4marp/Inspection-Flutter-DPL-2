import 'dart:async';

import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/inspection.dart';
import '../json_placeholder_mapper.dart';
import '../json_response_decoder.dart';

class ReadInspections {
  const ReadInspections({required this.client, required this.endpoints});

  final http.Client client;
  final ApiEndpoints endpoints;

  Future<List<Inspection>> call() async {
    final response = await client
        .get(endpoints.list)
        .timeout(endpoints.timeout);
    final posts = JsonResponseDecoder.list(response, expectedStatus: 200);
    return posts.map(JsonPlaceholderMapper.fromPost).toList(growable: false);
  }
}
