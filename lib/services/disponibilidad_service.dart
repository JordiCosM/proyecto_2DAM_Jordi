import 'package:reservapp_mobile/models/horario.dart';
import 'package:reservapp_mobile/models/reserva.dart';
import 'package:reservapp_mobile/models/servicio.dart';

enum EstadoDia { disponible, lleno, cerrado, pasado }

class SlotInfo {
  final String hora;
  final bool disponible;
  final int ocupadas;
  final int capacidad;

  const SlotInfo({
    required this.hora,
    required this.disponible,
    required this.ocupadas,
    required this.capacidad,
  });
}

class DisponibilidadService {
  static const _diaMap = {
    DateTime.monday: 'LUNES',
    DateTime.tuesday: 'MARTES',
    DateTime.wednesday: 'MIERCOLES',
    DateTime.thursday: 'JUEVES',
    DateTime.friday: 'VIERNES',
    DateTime.saturday: 'SABADO',
    DateTime.sunday: 'DOMINGO',
  };

  static List<String> _generarSlots(
    String apertura,
    String cierre,
    int duracionMin,
  ) {
    final slots = <String>[];
    final apParts = apertura.substring(0, 5).split(':');
    final ciParts = cierre.substring(0, 5).split(':');
    int actual = int.parse(apParts[0]) * 60 + int.parse(apParts[1]);
    final fin = int.parse(ciParts[0]) * 60 + int.parse(ciParts[1]);
    while (actual + duracionMin <= fin) {
      final h = (actual ~/ 60).toString().padLeft(2, '0');
      final m = (actual % 60).toString().padLeft(2, '0');
      slots.add('$h:$m');
      actual += duracionMin;
    }
    return slots;
  }

  static Horario? _getHorarioForDate(List<Horario> horarios, String fecha) {
    final weekday = DateTime.parse('${fecha}T00:00:00').weekday;
    final diaNombre = _diaMap[weekday];
    try {
      return horarios.firstWhere((h) => h.dia == diaNombre);
    } catch (_) {
      return null;
    }
  }

  static List<SlotInfo> getSlotsForDate({
    required List<Horario> horarios,
    required List<Reserva> reservas,
    required Servicio servicio,
    required String fecha,
  }) {
    final horario = _getHorarioForDate(horarios, fecha);
    if (horario == null) return [];

    final slotHoras = _generarSlots(
      horario.apertura,
      horario.cierre,
      servicio.duracion,
    );
    final reservasDia = reservas
        .where(
          (r) =>
              r.fecha == fecha &&
              r.estado != EstadoReserva.cancelada &&
              r.estado != EstadoReserva.finalizada,
        )
        .toList();
    final capacidad = servicio.capacidad;

    return slotHoras.map((hora) {
      final ocupadas = reservasDia
          .where((r) => r.horaInicio.substring(0, 5) == hora)
          .length;
      return SlotInfo(
        hora: hora,
        disponible: ocupadas < capacidad,
        ocupadas: ocupadas,
        capacidad: capacidad,
      );
    }).toList();
  }

  static EstadoDia getEstadoDia({
    required List<Horario> horarios,
    required List<Reserva> reservas,
    required Servicio servicio,
    required String fecha,
  }) {
    final hoy = DateTime.now();
    final diaDate = DateTime.parse('${fecha}T00:00:00');
    if (diaDate.isBefore(DateTime(hoy.year, hoy.month, hoy.day))) {
      return EstadoDia.pasado;
    }
    final slots = getSlotsForDate(
      horarios: horarios,
      reservas: reservas,
      servicio: servicio,
      fecha: fecha,
    );
    if (slots.isEmpty) return EstadoDia.cerrado;
    if (slots.every((s) => !s.disponible)) return EstadoDia.lleno;
    return EstadoDia.disponible;
  }
}
