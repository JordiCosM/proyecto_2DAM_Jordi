import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reservapp_mobile/config/app_config.dart';

class AuthService {
  static const _tokenKey = 'jwt_token';
  static const _timeout = Duration(seconds: 10);

  Future<bool> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.authUrl}/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'] as String?;
        if (token != null) await _saveToken(token);
        final id = jsonDecode(response.body)['idUsuario'];
        if (id != null) await _saveUserId((id as num).toInt());
        return token != null;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required bool isCompany,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.authUrl}/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nombre': name,
              'apellidos': surname,
              'email': email,
              'telefono': phone,
              'password': password,
              'rol': isCompany ? 'EMPRESA' : 'CLIENTE',
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = jsonDecode(response.body)['token'] as String?;
        if (token != null) await _saveToken(token);
        final id = jsonDecode(response.body)['idUsuario'];
        if (id != null) await _saveUserId((id as num).toInt());
        return token != null;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyToken() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return false;

      final response = await http
          .get(
            Uri.parse('${AppConfig.authUrl}/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (_) {
      return true;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.authUrl}/forgot-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('${AppConfig.authUrl}/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': token, 'nuevaPassword': newPassword}),
          )
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove(_tokenKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<void> _saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
  }
}
