import 'dart:convert';
import 'package:reservapp_mobile/models/ciudad.dart';
import 'package:reservapp_mobile/utils/api_client.dart';

class CiudadService {
  Future<List<Ciudad>> getCiudades() async {
    try {
      final response = await ApiClient.get('/ciudades');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Ciudad.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<Provincia>> getProvincias() async {
    try {
      final response = await ApiClient.get('/provincias');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Provincia.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
