class Viagem {
  final int? id;
  final String titulo;
  final String destino;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String descricao;

  Viagem({
    this.id,
    required this.titulo,
    required this.destino,
    required this.dataInicio,
    required this.dataFim,
    required this.descricao,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "destino": destino,
      "data_inicio": dataInicio.toIso8601String(),
      "data_fim": dataFim.toIso8601String(),
      "descricao": descricao,
    };
  }

  factory Viagem.fromMap(Map<String, dynamic> map) {
    return Viagem(
      id: map["id"] as int,
      titulo: map["titulo"] as String,
      destino: map["destino"] as String,
      dataInicio: DateTime.parse(map["data_inicio"] as String),
      dataFim: DateTime.parse(map["data_fim"] as String),
      descricao: map["descricao"] as String,
    );
  }
}
