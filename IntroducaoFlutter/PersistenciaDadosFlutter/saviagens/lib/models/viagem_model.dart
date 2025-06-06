import 'package:intl/intl.dart';

class Viagem {
  final int? id;
  final String titulo;
  final String destino;
  final DateTime data_inicio;
  final DateTime data_fim;

  Viagem({
    this.id,
    required this.titulo,
    required this.destino,
    required this.data_inicio,
    required this.data_fim,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "titulo": titulo,
      "destino": destino,
      "data_inicio": data_inicio,
      "data_fim": data_fim,
    };
  }

  factory Viagem.fromMap(Map<String, dynamic> map) {
    return Viagem(
      id: map["id"] as int,
      titulo: map["titulo"] as String,
      destino: map["destino"] as String,
      data_inicio: DateTime.parse(map["data_inicio"] as String),
      data_fim: DateTime.parse(map["data_fim"] as String),
    );
  }

  String get dataHoraFormatada{
    final DateFormat formatter = DateFormat("dd/MM/yyyy HH:mm");
    return formatter.format(data_inicio);
  }
}
