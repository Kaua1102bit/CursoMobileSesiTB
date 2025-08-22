class Livro {
  // atributos
  final String? id; // pode ser nulo inicialmente -> id será atribuido no bd
  final String titulo;
  final String autor;
  final bool disponivel;

  // construtor
  Livro({this.id, required this.titulo, required this.autor, required this.disponivel});

  // métodos
  // toJson
  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'autor': autor,
        'disponivel': disponivel,
      };

  // fromJson
  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
        id: json["id"].toString(),
        titulo: json["titulo"].toString(),
        autor: json["autor"].toString(),
        disponivel: json["disponivel"] is bool ? json["disponivel"] : json["disponivel"].toString().toLowerCase() == 'true',
      );
}
