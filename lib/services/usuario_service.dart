import 'dart:convert';
import 'package:reservapp_mobile/models/usuario.dart';
import 'package:reservapp_mobile/utils/api_client.dart';

class UsuarioService {
  Future<Usuario?> getUsuarioById(int id) async {
    try {
      final response = await ApiClient.get('/usuarios/$id');
      if (response.statusCode == 200) {
        return Usuario.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<Usuario?> updateUsuario(Usuario usuario) async {
    try {
      final response = await ApiClient.put(
        '/usuarios/${usuario.id}',
        usuario.toJson(),
      );
      if (response.statusCode == 200) {
        return Usuario.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteUsuario(int id) async {
    try {
      final response = await ApiClient.delete('/usuarios/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
