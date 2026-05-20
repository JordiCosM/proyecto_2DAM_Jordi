class Ciudad {
  final int id;
  final String nombre;
  final String codPostal;
  final int idProvincia;

  const Ciudad({
    required this.id,
    required this.nombre,
    required this.codPostal,
    required this.idProvincia,
  });

  factory Ciudad.fromJson(Map<String, dynamic> json) => Ciudad(
    id: json['id'] ?? 0,
    nombre: json['nombre'] ?? '',
    codPostal: json['codPostal'] ?? '',
    idProvincia: json['idProvincia'] ?? 0,
  );
}

class Provincia {
  final int id;
  final String nombre;

  const Provincia({required this.id, required this.nombre});

  factory Provincia.fromJson(Map<String, dynamic> json) =>
      Provincia(id: json['id'] ?? 0, nombre: json['nombre'] ?? '');
}
