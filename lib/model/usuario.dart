
class Usuario {
  final String id;
  final String nome;
  final DateTime? criadoEm;

  Usuario({
    required this.id,
    required this.nome,
    this.criadoEm,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as String,
      nome: map['nome'] as String,
      criadoEm: map['criado_em'] == null
          ? null
          : DateTime.parse(map['criado_em'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'criado_em': criadoEm?.toIso8601String(),
    };
  }
}