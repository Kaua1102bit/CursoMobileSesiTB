// classe de ajuda para conexão com API

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  //base url para conexão
  static const _baseUrl = "http:// 10.109.197.31:3008";

  //métodos static (métodos da classe e não do Obj)
  //GET -> Listar todos os recursos
  static Future<List<dynamic>> getList(String path) async {
    final res = await http.get(Uri.parse("$_baseUrl/$path"));
    if (res.statusCode == 200)
      return json.decode(res.body); // se deu certo interrompe o metodo
    // se não deu certo a conexão -> gerar um erro
    throw Exception(
      "Falha ao Carregar Lista de $path",
    ); //deve ser tratado em um try catch
  }

  //GET -> Listar apenas um recurso
  static Future<Map<String, dynamic>> getOne(String path, String id) async {
    final res = await http.get(Uri.parse("$_baseUrl/$path/$id"));
    if (res.statusCode == 200) return json.decode(res.body);
    //se der erro
    throw Exception("Erro ao carregar recurso de $path");
  }

  //POST -> adicionar Recurso
  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final res = await http.post(
      //URL/Head/Body
      Uri.parse("$_baseUrl/$path"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (res.statusCode == 201)
      return json.decode(res.body); // retorna o obj com id
    throw Exception("Falha ao Criar Recurso em $path");
  }

  //PUT -> Atualizar um Recurso
  static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
    String id,
  ) async {
    final res = await http.put(
      //URL/Head/Body
      Uri.parse("$_baseUrl/$path/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    if (res.statusCode == 200)
      return json.decode(res.body); // retorna o obj com id
    throw Exception("Falha ao Criar Recurso em $path");
  }

  //DELETE -> Deletar um Recurso
  static delete(String path, String id) async {
    final res = await http.delete(Uri.parse("$_baseUrl/$path/$id"));
      if(res.statusCode != 200) throw Exception("Falha ao Deletar Recurso de $path");
  }

}
