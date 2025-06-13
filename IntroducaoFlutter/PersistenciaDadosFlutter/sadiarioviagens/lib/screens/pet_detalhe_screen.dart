// tela de detalhes da viagem 
import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/viagens_controller.dart';
import 'package:sapetshop/controllers/consultas_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'dart:io';

import 'package:sapetshop/screens/viagem_detalhe.dart';

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

  Widget _buildLinhaDoTempo() {
    if (_entradas.isEmpty) {
      return const Center(child: Text("Nenhuma entrada cadastrada"));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _entradas.length,
        itemBuilder: (context, index) {
          final entrada = _entradas[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens no topo
            children: [
              // Linha vertical da timeline
              Column(
                children: [
                  Container(
                    width: 2,
                    height: index == 0 ? 30 : 60,
                    color: index == 0 ? Colors.transparent : Colors.blue.shade200,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      "${entrada.data.day}",
                      style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 2,
                    height: 60,
                    color: index == _entradas.length - 1 ? Colors.transparent : Colors.blue.shade200,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card( // Card para cada entrada
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entrada.data.day}/${entrada.data.month}/${entrada.data.year}",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                        ),
                        if (entrada.fotoPath != null && entrada.fotoPath!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(entrada.fotoPath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Text(
                          entrada.texto,
                          style: TextStyle(fontSize: 16),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () => _deleteEntrada(entrada.id!),
                            icon: Icon(Icons.delete, color: Colors.red[300]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
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
                      Text("Título: ${viagem!.titulo}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Destino: ${viagem!.destino}", style: TextStyle(fontSize: 16)),
                      Text("Início: ${viagem!.dataInicio.day}/${viagem!.dataInicio.month}/${viagem!.dataInicio.year}"),
                      Text("Fim: ${viagem!.dataFim.day}/${viagem!.dataFim.month}/${viagem!.dataFim.year}"),
                      Text("Descrição: ${viagem!.descricao}"),
                      Divider(),
                      Text("Linha do Tempo das Entradas Diárias:", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildLinhaDoTempo(),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEntradaScreen(viagemId: widget.viagemId)),
        ).then((_) => _loadViagemEntradas()),
        child: Icon(Icons.add),
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