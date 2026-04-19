import 'dart:convert';
import 'package:reservapp_mobile/models/servicio.dart';
import 'package:reservapp_mobile/utils/api_client.dart';

class ServicioService {
  Future<List<Servicio>> getAllServicios() async {
    try {
      final response = await ApiClient.get('/servicios');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Servicio.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<Servicio?> getServicioById(int id) async {
    try {
      final response = await ApiClient.get('/servicios/$id');
      if (response.statusCode == 200) {
        return Servicio.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<Servicio>> getServiciosByEmpresa(int idEmpresa) async {
    try {
      final response = await ApiClient.get('/servicios/empresa/$idEmpresa');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Servicio.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
