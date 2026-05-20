class Servicio {
  final int id;
  final int idEmpresa;
  final String nombre;
  final String descripcion;
  final int duracion;
  final double precio;
  final int capacidad;

  const Servicio({
    required this.id,
    required this.idEmpresa,
    required this.nombre,
    required this.descripcion,
    required this.duracion,
    required this.precio,
    required this.capacidad,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
    id: json['id'] ?? 0,
    idEmpresa: json['idEmpresa'] ?? 0,
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'] ?? '',
    duracion: json['duracion'] ?? 0,
    precio: (json['precio'] ?? 0).toDouble(),
    capacidad: ((json['capacidad'] as int?) ?? 1).clamp(1, 999999),
  );

  String get formattedPrecio => '${precio.toStringAsFixed(2)} €';

  String get formattedDuracion {
    if (duracion < 60) return '${duracion}min';
    final h = duracion ~/ 60;
    final m = duracion % 60;
    return m > 0 ? '${h}h ${m}min' : '${h}h';
  }
}
