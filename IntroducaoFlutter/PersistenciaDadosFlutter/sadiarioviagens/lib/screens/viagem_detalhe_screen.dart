// tela de detalhes da viagem 
import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/viagens_controller.dart';
import 'package:sapetshop/controllers/consultas_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/screens/add_consulta_screen.dart';
import 'dart:io';

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
      _entradas.sort((a, b) => a.data.compareTo(b.data));
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
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          "${entrada.data.day}",
                          style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${entrada.data.month}/${entrada.data.year}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (entrada.fotoPath != null && entrada.fotoPath!.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
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
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _deleteEntrada(entrada.id!),
                    icon: Icon(Icons.delete, color: Colors.red[300]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da Viagem"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : viagem == null
              ? const Center(child: Text("Erro ao carregar a viagem"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade100, Colors.blue.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade100.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viagem!.titulo,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              viagem!.destino,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.blue.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  "Início: ${viagem!.dataInicio.day}/${viagem!.dataInicio.month}/${viagem!.dataInicio.year}",
                                  style: TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.flag, size: 16, color: Colors.blue.shade400),
                                const SizedBox(width: 4),
                                Text(
                                  "Fim: ${viagem!.dataFim.day}/${viagem!.dataFim.month}/${viagem!.dataFim.year}",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              viagem!.descricao,
                              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Linha do Tempo das Entradas Diárias",
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildLinhaDoTempo(),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
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