class Reserva {
  final int id;
  final int idUsuario;
  final int idServicio;
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final EstadoReserva estado;
  final List<int> idEmpleados;

  const Reserva({
    required this.id,
    required this.idUsuario,
    required this.idServicio,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
    required this.idEmpleados,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
    id: json['id'] ?? 0,
    idUsuario: json['idUsuario'] ?? 0,
    idServicio: json['idServicio'] ?? 0,
    fecha: json['fecha'] ?? '',
    horaInicio: json['horaInicio'] ?? '',
    horaFin: json['horaFin'] ?? '',
    estado: EstadoReserva.fromString(json['estado']),
    idEmpleados:
        (json['idEmpleados'] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList() ??
        [],
  );

  Map<String, dynamic> toJson() => {
    'idUsuario': idUsuario,
    'idServicio': idServicio,
    'fecha': fecha,
    'horaInicio': horaInicio,
    'horaFin': horaFin,
    'estado': estado.value,
    'idEmpleados': idEmpleados,
  };

  DateTime get dateTime {
    try {
      return DateTime.parse('$fecha $horaInicio');
    } catch (_) {
      return DateTime.now();
    }
  }
}

enum EstadoReserva {
  pendiente,
  confirmada,
  cancelada,
  finalizada;

  static EstadoReserva fromString(String? s) => switch (s?.toUpperCase()) {
    'CONFIRMADA' => EstadoReserva.confirmada,
    'CANCELADA' => EstadoReserva.cancelada,
    'FINALIZADA' => EstadoReserva.finalizada,
    _ => EstadoReserva.pendiente,
  };

  String get value => name.toUpperCase();

  String get label => switch (this) {
    EstadoReserva.pendiente => 'Pendiente',
    EstadoReserva.confirmada => 'Confirmada',
    EstadoReserva.cancelada => 'Cancelada',
    EstadoReserva.finalizada => 'Finalizada',
  };
}
