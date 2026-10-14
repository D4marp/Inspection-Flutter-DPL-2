import 'package:dpl_inspection_day_2/src/config/api_endpoints.dart';
import 'package:dpl_inspection_day_2/src/config/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Env defaults point to the public JSONPlaceholder API', () {
    expect(Env.apiBaseUrl, 'https://jsonplaceholder.typicode.com');
    expect(Env.apiPostsPath, '/posts');
  });

  test('ApiEndpoints builds every URL from configuration', () {
    const endpoints = ApiEndpoints(
      baseUrl: 'https://example.test',
      postsPath: '/items',
      listLimit: 5,
    );
    expect(endpoints.list.toString(), 'https://example.test/items?_limit=5');
    expect(endpoints.collection.toString(), 'https://example.test/items');
    expect(endpoints.item('9').toString(), 'https://example.test/items/9');
  });
}
