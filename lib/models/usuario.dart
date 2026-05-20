class Usuario {
  final int id;
  final String nombre;
  final String apellidos;
  final String email;
  final String telefono;
  final String rol;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.telefono,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'] ?? 0,
    nombre: json['nombre'] ?? '',
    apellidos: json['apellidos'] ?? '',
    email: json['email'] ?? '',
    telefono: json['telefono'] ?? '',
    rol: json['rol'] ?? 'CLIENTE',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'apellidos': apellidos,
    'email': email,
    'telefono': telefono,
    'rol': rol,
  };

  String get nombreCompleto => '$nombre $apellidos'.trim();

  String get iniciales {
    final n = nombre.isNotEmpty ? nombre[0] : '';
    final a = apellidos.isNotEmpty ? apellidos[0] : '';
    return '$n$a'.toUpperCase();
  }
}
