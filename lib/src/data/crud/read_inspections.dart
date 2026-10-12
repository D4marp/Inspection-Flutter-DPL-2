import 'dart:async';

import 'package:http/http.dart' as http;

import '../../models/inspection.dart';
import '../json_placeholder_mapper.dart';
import '../json_response_decoder.dart';

class ReadInspections {
  const ReadInspections({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<List<Inspection>> call() async {
    final response = await client
        .get(Uri.parse('$baseUrl/posts?_limit=20'))
        .timeout(const Duration(seconds: 10));
    final posts = JsonResponseDecoder.list(response, expectedStatus: 200);
    return posts.map(JsonPlaceholderMapper.fromPost).toList(growable: false);
  }
}
