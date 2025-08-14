import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: TarefasPage()));
}

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TarefasPageState();
  }
}

class _TarefasPageState extends State<TarefasPage> {
  //atributos
  //Lista de tarefas<Map>
  List<Map<String, dynamic>> _tarefas = [];
  //controlador para o TextField
  final TextEditingController _tarefaController = TextEditingController();
  // endereço da API
  final String baseUrl = "http://10.109.197.14:3008/tarefas";

  //métodos
  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print("GET tarefas status: ${response.statusCode}");
      print("GET tarefas body: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> dados = json.decode(response.body);
        setState(() {
          _tarefas = dados
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
        });
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao carregar tarefas: ${response.statusCode}'),
            ),
          );
        }
      }
    } catch (e) {
      print("Erro ao carregar API: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao carregar tarefas: $e')));
      }
    }
  }

  void _adicionarTarefa(String titulo) async {
    if (titulo.trim().isEmpty) return;
    try {
      final tarefa = {"titulo": titulo, "concluida": false};
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tarefa),
      );
      print("POST tarefa status: ${response.statusCode}");
      print("POST tarefa body: ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        _tarefaController.clear();
        _carregarTarefas();
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao adicionar tarefa: ${response.statusCode}\n${response.body}',
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Erro ao adicionar tarefa $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao adicionar tarefa: $e')));
      }
    }
  }

  //remover tarefas
  void _removerTarefa(String id) async {
    try {
      //solicitação http -> delete (URL + ID)
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        _carregarTarefas(); // Removido o setState daqui
      }
    } catch (e) {
      print("Erro ao deletar Tarefa $e");
    }
  }

  //atualizar tarefa
  void _atualizarTarefa(String id, bool concluida) async {
    try {
      final tarefa = {"concluida": concluida};
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(tarefa),
      );
      if (response.statusCode == 200) {
        _carregarTarefas(); // Removido o setState daqui
      }
    } catch (e) {
      print("Erro ao atualizar tarefa $e");
    }
  }

  //build Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tarefas via API")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tarefaController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _adicionarTarefa(value);
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    final value = _tarefaController.text;
                    if (value.trim().isNotEmpty) {
                      _adicionarTarefa(value);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              //operador ternário
              child: _tarefas.isEmpty
                  ? Center(child: Text("Nenhuma Tarefa Cadastrada"))
                  : ListView.builder(
                      itemCount: _tarefas.length,
                      itemBuilder: (context, index) {
                        final tarefa = _tarefas[index];
                        return ListTile(
                          //leading para criar um checkbox(atualizar)
                          title: Text(tarefa["titulo"]),
                          subtitle: Text(
                            tarefa["concluida"] ? "Concluída" : "Pendente",
                          ),
                          trailing: IconButton(
                            onPressed: () => _removerTarefa(tarefa["id"]),
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
