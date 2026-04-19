class AppConfig {
  AppConfig._();

  // - Android: http://10.0.2.2:8080/api
  // - iOS: http://localhost:8080/api
  // - Pc: http://<IP_local>:8080/api
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  static const String authUrl = '$baseUrl/auth';
}
