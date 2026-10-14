/// Konfigurasi compile-time dari `--dart-define-from-file=env/<nama>.json`.
///
/// Semua endpoint dibaca di sini; tidak ada URL yang di-hardcode di data layer.
class Env {
  const Env._();

  static const name = String.fromEnvironment('ENV_NAME', defaultValue: 'dev');
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );
  static const apiPostsPath = String.fromEnvironment(
    'API_POSTS_PATH',
    defaultValue: '/posts',
  );
  static const apiListLimit = int.fromEnvironment(
    'API_LIST_LIMIT',
    defaultValue: 20,
  );
  static const apiTimeoutSeconds = int.fromEnvironment(
    'API_TIMEOUT_SECONDS',
    defaultValue: 10,
  );

  static const apiTimeout = Duration(seconds: apiTimeoutSeconds);
}
