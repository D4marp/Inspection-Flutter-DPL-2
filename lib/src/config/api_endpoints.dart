import 'env.dart';

/// Satu-satunya tempat yang merakit URL endpoint dari konfigurasi.
class ApiEndpoints {
  const ApiEndpoints({
    required this.baseUrl,
    this.postsPath = Env.apiPostsPath,
    this.listLimit = Env.apiListLimit,
    this.timeout = Env.apiTimeout,
  });

  final String baseUrl;
  final String postsPath;
  final int listLimit;
  final Duration timeout;

  Uri get list => Uri.parse(
    '$baseUrl$postsPath',
  ).replace(queryParameters: {'_limit': '$listLimit'});

  Uri get collection => Uri.parse('$baseUrl$postsPath');

  Uri item(String id) => Uri.parse('$baseUrl$postsPath/$id');
}
