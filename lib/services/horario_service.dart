import 'dart:convert';
import 'package:reservapp_mobile/models/horario.dart';
import 'package:reservapp_mobile/utils/api_client.dart';

class HorarioService {
  Future<List<Horario>> getHorariosByEmpresa(int idEmpresa) async {
    try {
      final response = await ApiClient.get('/horarios/empresa/$idEmpresa');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Horario.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
