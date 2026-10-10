import 'package:flutter/foundation.dart';

import '../data/api_client.dart';
import '../data/inspection_repository.dart';

enum SessionStatus { starting, signedOut, signedIn }

class SessionController extends ChangeNotifier {
  SessionController(this.api, this.repository);
  final ApiClient api;
  final InspectionRepository repository;

  SessionStatus status = SessionStatus.starting;
  bool isBusy = false;
  String? errorMessage;

  Future<void> initialize({bool autoLogin = false}) async {
    final token = await api.readToken();
    if (autoLogin && (token == null || token.isEmpty)) {
      await login('trainer', 'training123');
      return;
    }
    status = token == null || token.isEmpty
        ? SessionStatus.signedOut
        : SessionStatus.signedIn;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    if (isBusy) return;
    isBusy = true;
    errorMessage = null;
    notifyListeners();
    try {
      await api.login(username.trim(), password);
      status = SessionStatus.signedIn;
    } on ApiException catch (error) {
      errorMessage = error.message;
    } on Object {
      errorMessage =
          'Tidak dapat terhubung ke API. Pastikan mock server aktif.';
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await repository.clearSession();
    status = SessionStatus.signedOut;
    errorMessage = null;
    notifyListeners();
  }

  void expire() {
    status = SessionStatus.signedOut;
    errorMessage = 'Session berakhir. Silakan login kembali.';
    notifyListeners();
  }
}
