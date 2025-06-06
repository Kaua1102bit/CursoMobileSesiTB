// tela de detalhes da viagem 
import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/viagens_controller.dart';
import 'package:sapetshop/controllers/consultas_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/screens/add_consulta_screen.dart';

class ViagemDetalheScreen extends StatefulWidget {
  final int viagemId;

  const ViagemDetalheScreen({Key? key, required this.viagemId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViagemDetalheScreenState();
}

class _ViagemDetalheScreenState extends State<ViagemDetalheScreen> {
  final ViagensController _controllerViagens = ViagensController();
  final EntradasDiariasController _controllerEntradas = EntradasDiariasController();
  bool _isLoading = true;

  Viagem? viagem;
  List<EntradaDiaria> _entradas = [];

  @override
  void initState() {
    super.initState();
    _loadViagemEntradas();
  }

  Future<void> _loadViagemEntradas() async {
    try {
      viagem = await _controllerViagens.findViagemById(widget.viagemId);
      _entradas = await _controllerEntradas.getEntradasByViagem(widget.viagemId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes da Viagem")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : viagem == null
              ? const Center(child: Text("Erro ao carregar a viagem"))
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Título: ${viagem!.titulo}"),
                      Text("Destino: ${viagem!.destino}"),
                      Text("Início: ${viagem!.dataInicio.day}/${viagem!.dataInicio.month}/${viagem!.dataInicio.year}"),
                      Text("Fim: ${viagem!.dataFim.day}/${viagem!.dataFim.month}/${viagem!.dataFim.year}"),
                      Text("Descrição: ${viagem!.descricao}"),
                      Divider(),
                      Text("Entradas Diárias:"),
                      _entradas.isEmpty
                          ? Center(child: Text("Nenhuma entrada cadastrada"))
                          : Expanded(
                              child: ListView.builder(
                                itemCount: _entradas.length,
                                itemBuilder: (context, index) {
                                  final entrada = _entradas[index];
                                  return ListTile(
                                    title: Text(entrada.texto),
                                    subtitle: Text("${entrada.data.day}/${entrada.data.month}/${entrada.data.year}"),
                                    trailing: IconButton(
                                      onPressed: () => _deleteEntrada(entrada.id!),
                                      icon: Icon(Icons.delete),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEntradaScreen(viagemId: widget.viagemId)),
        ),
      ),
    );
  }

  void _deleteEntrada(int entradaId) async {
    await _controllerEntradas.deleteEntrada(entradaId);
    _loadViagemEntradas();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Entrada deletada com sucesso!")),
    );
  }
}