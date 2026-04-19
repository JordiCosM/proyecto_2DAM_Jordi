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
  );
}
