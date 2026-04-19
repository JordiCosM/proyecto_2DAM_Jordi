import 'dart:convert';
import 'package:reservapp_mobile/models/reserva.dart';
import 'package:reservapp_mobile/utils/api_client.dart';

class ReservaService {
  Future<List<Reserva>> getReservasByUsuario(int idUsuario) async {
    try {
      final response = await ApiClient.get('/reservas/usuario/$idUsuario');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((j) => Reserva.fromJson(j))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<Reserva?> createReserva(Reserva reserva) async {
    try {
      final response = await ApiClient.post('/reservas', reserva.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Reserva.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> cancelarReserva(int id) async {
    try {
      final response = await ApiClient.patch('/reservas/$id/estado', {
        'estado': EstadoReserva.cancelada.value,
      });
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> eliminarReserva(int id) async {
    try {
      final response = await ApiClient.delete('/reservas/$id');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
