class Emprestimo {
	// atributos
	final String? id; // pode ser nulo inicialmente -> id será atribuido no bd
	final String usuario;
	final String livro;
	final String dataEmprestimo;
	final String dataDevolucao;
	final bool devolvido;

	// construtor
	Emprestimo({
		this.id,
		required this.usuario,
		required this.livro,
		required this.dataEmprestimo,
		required this.dataDevolucao,
		required this.devolvido,
	});

	// métodos
	// toJson
	Map<String, dynamic> toJson() => {
				'id': id,
				'usuario': usuario,
				'livro': livro,
				'dataEmprestimo': dataEmprestimo,
				'dataDevolucao': dataDevolucao,
				'devolvido': devolvido,
			};

	// fromJson
	factory Emprestimo.fromJson(Map<String, dynamic> json) => Emprestimo(
				id: json["id"].toString(),
				usuario: json["usuario"].toString(),
				livro: json["livro"].toString(),
				dataEmprestimo: json["dataEmprestimo"].toString(),
				dataDevolucao: json["dataDevolucao"].toString(),
				devolvido: json["devolvido"] is bool ? json["devolvido"] : json["devolvido"].toString().toLowerCase() == 'true',
			);
}
