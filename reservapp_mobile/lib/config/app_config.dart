class AppConfig {
  AppConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8080/api',
  );
  static const String authUrl = '$baseUrl/auth';
  static const String imgBaseUrl = String.fromEnvironment(
    'IMG_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
}
