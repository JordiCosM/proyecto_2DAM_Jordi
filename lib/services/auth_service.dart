import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8080/api/auth";

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 10));

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt_token", token);

        return true;
      }

      return false;
    } catch (e) {
      print("ERROR LOGIN: $e");
      return false;
    }
  }

  // Future<bool> register({
  //   required String name,
  //   required String surname,
  //   required String phone,
  //   required String email,
  //   required String password,
  //   required bool isCompany,
  // }) async {
  //   try {
  //     final url = Uri.parse("$baseUrl/register");

  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "name": name,
  //         "surname": surname,
  //         "phone": phone,
  //         "email": email,
  //         "password": password,
  //         "role": isCompany ? "COMPANY" : "CLIENT"
  //       }),
  //     );

  //     print("STATUS REGISTER: ${response.statusCode}");
  //     print("BODY REGISTER: ${response.body}");

  //     return response.statusCode == 201 || response.statusCode == 200;
  //   } catch (e) {
  //     print("ERROR REGISTER: $e");
  //     return false;
  //   }
  // }
  Future<bool> register({
    required String name,
    required String surname,
    required String phone,
    required String email,
    required String password,
    required bool isCompany,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": name,
          "apellidos": surname,
          "email": email,
          "telefono": phone,
          "password": password,
          "role": isCompany ? "empresa" : "cliente",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data["token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("jwt_token", token);

        return true;
      }
      return false;
    } catch (e) {
      print("ERROR REGISTER: $e");
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("jwt_token");
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("jwt_token");
  }
}
