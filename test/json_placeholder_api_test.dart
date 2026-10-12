import 'dart:convert';

import 'package:dpl_inspection_day_2/src/data/api_client.dart';
import 'package:dpl_inspection_day_2/src/models/inspection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('GET posts maps public JSON into inspection domain', () async {
    final client = ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      httpClient: MockClient((request) async {
        expect(request.url.path, '/posts');
        expect(request.url.queryParameters['_limit'], '20');
        return http.Response(
          jsonEncode([
            {'userId': 4, 'id': 7, 'title': 'Title', 'body': 'Body'},
          ]),
          200,
        );
      }),
    );

    final items = await client.fetchInspections();
    expect(items.single.assetCode, 'POST-007');
    expect(items.single.location, 'User 4');
    expect(items.single.condition, InspectionCondition.needsAction);
  });

  test('POST sends adapter fields and maps simulated response', () async {
    final client = ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/posts');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['title'], 'PMP-900');
        return http.Response(jsonEncode({...body, 'id': 101}), 201);
      }),
    );

    final item = await client.createInspection({
      'assetCode': 'PMP-900',
      'location': 'Workshop',
      'condition': 'good',
      'note': 'Simulasi create',
    });
    expect(item.id, '101');
    expect(item.assetCode, 'PMP-900');
  });

  test('PUT sends the selected id and maps simulated response', () async {
    final client = ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      httpClient: MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/posts/7');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['id'], 7);
        expect(body['title'], 'PMP-007');
        return http.Response(jsonEncode(body), 200);
      }),
    );

    final item = await client.updateInspection('7', {
      'assetCode': 'PMP-007',
      'location': 'Dock 2',
      'condition': 'needs_action',
      'note': 'Bearing perlu diperiksa',
    });
    expect(item.id, '7');
    expect(item.location, 'Dock 2');
  });

  test('DELETE accepts JSONPlaceholder 200 simulation response', () async {
    final client = ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      httpClient: MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/posts/1');
        return http.Response('{}', 200);
      }),
    );

    await client.deleteInspection('1');
  });
}
