import 'package:http/http.dart' as http;

import '../config/api_endpoints.dart';
import '../models/inspection.dart';
import 'crud/create_inspection.dart';
import 'crud/delete_inspection.dart';
import 'crud/read_inspections.dart';
import 'crud/update_inspection.dart';

export 'api_exception.dart';

class ApiClient {
  ApiClient({
    required this.baseUrl,
    ApiEndpoints? endpoints,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client() {
    final uri = Uri.tryParse(baseUrl);
    if (uri == null || uri.scheme != 'https' || !uri.hasAuthority) {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        'JSONPlaceholder harus menggunakan URL HTTPS yang valid',
      );
    }
    final routes = endpoints ?? ApiEndpoints(baseUrl: baseUrl);
    read = ReadInspections(client: _http, endpoints: routes);
    create = CreateInspection(client: _http, endpoints: routes);
    update = UpdateInspection(client: _http, endpoints: routes);
    delete = DeleteInspection(client: _http, endpoints: routes);
  }

  final String baseUrl;
  final http.Client _http;
  late final ReadInspections read;
  late final CreateInspection create;
  late final UpdateInspection update;
  late final DeleteInspection delete;

  Future<List<Inspection>> fetchInspections() => read();

  Future<Inspection> createInspection(Map<String, dynamic> fields) =>
      create(fields);

  Future<Inspection> updateInspection(String id, Map<String, dynamic> fields) =>
      update(id, fields);

  Future<void> deleteInspection(String id) => delete(id);

  void close() => _http.close();
}
