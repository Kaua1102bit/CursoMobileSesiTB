import 'package:intl/intl.dart';

class EntradaDiaria {
  final int? id;
  final int viagemId;
  final DateTime data;
  final String texto;
  final String? fotoPath;

  EntradaDiaria({
    this.id,
    required this.viagemId,
    required this.data,
    required this.texto,
    this.fotoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "viagem_id": viagemId,
      "data": data.toIso8601String(),
      "texto": texto,
      "foto_path": fotoPath,
    };
  }

  factory EntradaDiaria.fromMap(Map<String, dynamic> map) {
    return EntradaDiaria(
      id: map["id"] as int,
      viagemId: map["viagem_id"] as int,
      data: DateTime.parse(map["data"] as String),
      texto: map["texto"] as String,
      fotoPath: map["foto_path"] as String?,
    );
  }

  //Formatacao de data e Hora em formato Regional
  String get dataHoraFormata {
    final formatter = DateFormat("dd/MM/yyyy HH:mm");
    return formatter.format(data);
  }

  @override
  String toString() {
    return "EntradaDiaria{id: $id, viagemId: $viagemId, data: $data, texto: $texto, fotoPath: $fotoPath}";
  }
}

