//classe de controller do usuário

import 'package:biblioteca_app/services/api_services.dart';
import 'package:biblioteca_app/models/usuario.dart';

class UsuarioController {
  //métodos
  //get do usuário
  Future<List<Usuario>> fetchAll() async {
    //pega a lista de usuario no formato List<dynamic>
    final list = await ApiServices.getList("usuarios?_sort=nome");

    //retornar a lista de Usuários convertidas
    return list.map((item)=>Usuario.fromJson(item)).toList();
  }
  //Get de um unico Usuário
  Future<Usuario> fetchOne(String id) async {
    final usuario = await ApiServices.getOne("usuarios", id);
    return Usuario.fromJson(usuario);
  }
  //Post -> Criar um Novo usuário

  //Put -> Alterar um usuário

  // delete -> Deletar um usuário
}