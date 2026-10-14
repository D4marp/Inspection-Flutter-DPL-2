import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/inspection.dart';
import '../json_placeholder_mapper.dart';
import '../json_response_decoder.dart';

class CreateInspection {
  const CreateInspection({required this.client, required this.endpoints});

  final http.Client client;
  final ApiEndpoints endpoints;

  Future<Inspection> call(Map<String, dynamic> fields) async {
    final response = await client
        .post(
          endpoints.collection,
          headers: const {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(JsonPlaceholderMapper.toPost(fields)),
        )
        .timeout(endpoints.timeout);
    final post = JsonResponseDecoder.object(response, expectedStatus: 201);
    return JsonPlaceholderMapper.fromPost(post);
  }
}
