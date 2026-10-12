import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/inspection.dart';
import '../json_placeholder_mapper.dart';
import '../json_response_decoder.dart';

class CreateInspection {
  const CreateInspection({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl;

  Future<Inspection> call(Map<String, dynamic> fields) async {
    final response = await client
        .post(
          Uri.parse('$baseUrl/posts'),
          headers: const {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(JsonPlaceholderMapper.toPost(fields)),
        )
        .timeout(const Duration(seconds: 10));
    final post = JsonResponseDecoder.object(response, expectedStatus: 201);
    return JsonPlaceholderMapper.fromPost(post);
  }
}
