import 'package:flutter/foundation.dart';

import '../data/api_client.dart';
import '../data/inspection_repository.dart';
import '../models/inspection.dart';

class InspectionController extends ChangeNotifier {
  InspectionController(this.repository);
  final InspectionRepository repository;

  List<Inspection> items = const [];
  bool isLoading = false;
  bool isSubmitting = false;
  bool isCached = false;
  DateTime? fetchedAt;
  String? errorMessage;
  bool _disposed = false;

  Future<void> load() async {
    if (isLoading || _disposed) return;
    isLoading = true;
    errorMessage = null;
    _emit();
    try {
      final result = await repository.list();
      if (_disposed) return;
      items = result.items;
      isCached = result.isCached;
      fetchedAt = result.fetchedAt;
    } on Object catch (error) {
      if (!_disposed) _handle(error);
    } finally {
      isLoading = false;
      _emit();
    }
  }

  Future<Inspection?> create(Map<String, dynamic> fields) async {
    if (isSubmitting || isLoading || isCached || _disposed) return null;
    isSubmitting = true;
    errorMessage = null;
    _emit();
    try {
      final item = await repository.create(fields);
      if (_disposed) return null;
      items = [item, ...items.where((existing) => existing.id != item.id)];
      return item;
    } on Object catch (error) {
      if (!_disposed) _handle(error);
      return null;
    } finally {
      isSubmitting = false;
      _emit();
    }
  }

  Future<Inspection?> update(String id, Map<String, dynamic> fields) async {
    if (isSubmitting || isLoading || isCached || _disposed) return null;
    isSubmitting = true;
    errorMessage = null;
    _emit();
    try {
      final item = await repository.update(id, fields);
      if (_disposed) return null;
      items = items
          .map((existing) => existing.id == item.id ? item : existing)
          .toList(growable: false);
      return item;
    } on Object catch (error) {
      if (!_disposed) _handle(error);
      return null;
    } finally {
      isSubmitting = false;
      _emit();
    }
  }

  Future<bool> delete(String id) async {
    if (isSubmitting || isLoading || isCached || _disposed) return false;
    isSubmitting = true;
    errorMessage = null;
    _emit();
    try {
      await repository.delete(id);
      if (_disposed) return false;
      items = items.where((item) => item.id != id).toList(growable: false);
      return true;
    } on Object catch (error) {
      if (!_disposed) _handle(error);
      return false;
    } finally {
      isSubmitting = false;
      _emit();
    }
  }

  void _handle(Object error) {
    errorMessage = error is ApiException
        ? error.message
        : 'Terjadi kesalahan. Coba lagi.';
  }

  void _emit() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
