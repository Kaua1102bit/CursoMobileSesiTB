import 'dart:convert';

void main() {
  String jsonString = '''{
                          "usuario": "João",
                          "login":"joao_user",
                          "senha":1234,
                          "ativo": true
                          }''';

  Map<String, dynamic> usuario = json.decode(jsonString);

  print(usuario["ativo"]);

  // manipular Json usando o MAP
  usuario["ativo"] = false;

  // fazer o encode Map => Json(texto)
  jsonString = json.encode(usuario);

  // mostrar o texto no formato JSON
  print(jsonString);
}
