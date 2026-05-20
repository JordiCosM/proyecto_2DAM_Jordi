import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reservapp_mobile/config/app_config.dart';

class ApiClient {
  static const _timeout = Duration(seconds: 10);

  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String path) {
    return _exec(
      () async => http.get(
        Uri.parse('${AppConfig.baseUrl}$path'),
        headers: await _headers(),
      ),
    );
  }

  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    return _exec(
      () async => http.post(
        Uri.parse('${AppConfig.baseUrl}$path'),
        headers: await _headers(),
        body: jsonEncode(body),
      ),
    );
  }

  static Future<http.Response> put(String path, Map<String, dynamic> body) {
    return _exec(
      () async => http.put(
        Uri.parse('${AppConfig.baseUrl}$path'),
        headers: await _headers(),
        body: jsonEncode(body),
      ),
    );
  }

  static Future<http.Response> patch(String path, Map<String, dynamic> body) {
    return _exec(
      () async => http.patch(
        Uri.parse('${AppConfig.baseUrl}$path'),
        headers: await _headers(),
        body: jsonEncode(body),
      ),
    );
  }

  static Future<http.Response> delete(String path) {
    return _exec(
      () async => http.delete(
        Uri.parse('${AppConfig.baseUrl}$path'),
        headers: await _headers(),
      ),
    );
  }

  static Future<http.Response> _exec(
    Future<http.Response> Function() call,
  ) async {
    return call().timeout(_timeout);
  }
}
