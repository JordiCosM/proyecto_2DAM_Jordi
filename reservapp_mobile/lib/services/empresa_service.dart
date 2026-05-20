import 'dart:convert';
import 'package:reservapp_mobile/models/empresa.dart';
import 'package:reservapp_mobile/models/servicio.dart';
import 'package:reservapp_mobile/utils/api_client.dart';

class EmpresaService {
  Future<List<Empresa>> getEmpresas() async {
    try {
      final response = await ApiClient.get('/empresas');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Empresa.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<Empresa?> getEmpresaById(int id) async {
    try {
      final response = await ApiClient.get('/empresas/$id');
      if (response.statusCode == 200) {
        return Empresa.fromJson(jsonDecode(response.body));
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
