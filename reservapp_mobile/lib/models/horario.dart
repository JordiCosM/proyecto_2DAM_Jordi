class Horario {
  final int id;
  final int idEmpresa;
  final String dia;
  final String apertura;
  final String cierre;

  const Horario({
    required this.id,
    required this.idEmpresa,
    required this.dia,
    required this.apertura,
    required this.cierre,
  });

  factory Horario.fromJson(Map<String, dynamic> json) => Horario(
    id: json['id'] ?? 0,
    idEmpresa: json['idEmpresa'] ?? 0,
    dia: json['dia'] ?? '',
    apertura: json['apertura'] ?? '00:00:00',
    cierre: json['cierre'] ?? '00:00:00',
  );
}
