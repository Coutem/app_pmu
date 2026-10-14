class Documento {
  final int? id;
  final int consultaId;

  final String nomeArquivo;
  final String caminhoArquivo;
  final String? tipoArquivo;
  final int? tamanho;

  Documento({
    this.id,
    required this.consultaId,
    required this.nomeArquivo,
    required this.caminhoArquivo,
    this.tipoArquivo,
    this.tamanho,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'consulta_id': consultaId,
      'nome_arquivo': nomeArquivo,
      'caminho_arquivo': caminhoArquivo,
      'tipo_arquivo': tipoArquivo,
      'tamanho': tamanho,
    };
  }

  factory Documento.fromMap(Map<String, dynamic> map) {
    return Documento(
      id: map['id'],
      consultaId: map['consulta_id'],
      nomeArquivo: map['nome_arquivo'],
      caminhoArquivo: map['caminho_arquivo'],
      tipoArquivo: map['tipo_arquivo'],
      tamanho: map['tamanho'],
    );
  }
}