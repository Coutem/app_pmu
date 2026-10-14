class Consulta {
  final int? id;
  final int usuarioId;

  final String hospital;
  final String medico;
  final String especialidade;
  final String endereco;

  final DateTime data;
  final String horario;

  final String? observacao;

  Consulta({
    this.id,
    required this.usuarioId,
    required this.hospital,
    required this.medico,
    required this.especialidade,
    required this.endereco,
    required this.data,
    required this.horario,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'hospital': hospital,
      'medico': medico,
      'especialidade': especialidade,
      'endereco': endereco,
      'data': data.toIso8601String(),
      'horario': horario,
      'observacao': observacao,
    };
  }

  factory Consulta.fromMap(Map<String, dynamic> map) {
    return Consulta(
      id: map['id'],
      usuarioId: map['usuario_id'],
      hospital: map['hospital'],
      medico: map['medico'],
      especialidade: map['especialidade'],
      endereco: map['endereco'],
      data: DateTime.parse(map['data']),
      horario: map['horario'],
      observacao: map['observacao'],
    );
  }
}