import 'package:reservapp_mobile/config/app_config.dart';

class Empresa {
  final int id;
  final int idUsuario;
  final int idCiudad;
  final String nombre;
  final String descripcion;
  final String direccion;
  final String telefono;
  final String email;
  final String sector;
  final String? logoUrl;
  final List<String> imagenes;

  const Empresa({
    required this.id,
    required this.idUsuario,
    required this.idCiudad,
    required this.nombre,
    required this.descripcion,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.sector,
    this.logoUrl,
    this.imagenes = const [],
  });

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
    id: json['id'] ?? 0,
    idUsuario: json['idUsuario'] ?? 0,
    idCiudad: json['idCiudad'] ?? 0,
    nombre: json['nombre'] ?? '',
    descripcion: json['descripcion'] ?? '',
    direccion: json['direccion'] ?? '',
    telefono: json['telefono'] ?? '',
    email: json['email'] ?? '',
    sector: json['sector'] ?? '',
    logoUrl: json['logoUrl'],
    imagenes: (json['imagenes'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
  );

  String? get logoUrlAbsoluta => (logoUrl != null && logoUrl!.isNotEmpty)
      ? '${AppConfig.imgBaseUrl}$logoUrl'
      : null;

  List<String> get imagenesAbsolutas =>
      imagenes.map((e) => '${AppConfig.imgBaseUrl}$e').toList();
}
