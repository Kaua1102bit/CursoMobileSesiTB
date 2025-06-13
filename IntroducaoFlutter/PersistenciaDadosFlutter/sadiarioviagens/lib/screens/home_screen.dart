import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/viagens_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/screens/add_viagem_screen.dart';
import 'package:sapetshop/screens/viagem_detalhe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ViagensController _viagensController = ViagensController();

  List<Viagem> _viagens = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViagens();
  }

  Future<void> _loadViagens() async {
    setState(() {
      _isLoading = true;
      _viagens = [];
    });
    try {
      _viagens = await _viagensController.fetchViagens();
    } catch (erro) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception: $erro")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removerViagem(int id) async {
    await _viagensController.deleteViagem(id);
    await _loadViagens();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Viagem removida com sucesso!")),
    );
  }

  Future<void> _editarViagem(Viagem viagem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddViagemScreen(
          viagem: viagem,
        ),
      ),
    );
    await _loadViagens();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Viagens"),
        backgroundColor: Colors.blue.shade700,
        elevation: 4,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _viagens.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.travel_explore, size: 80, color: Colors.blue.shade200),
                      SizedBox(height: 16),
                      Text(
                        "Nenhuma viagem cadastrada ainda.",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Toque no botão '+' para adicionar sua primeira viagem!",
                        style: TextStyle(fontSize: 14, color: Colors.blue.shade400),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _viagens.length,
                  itemBuilder: (context, index) {
                    final viagem = _viagens[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 5,
                      shadowColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          radius: 28,
                          child: Icon(Icons.flight_takeoff, color: Colors.blue.shade700, size: 28),
                        ),
                        title: Text(
                          viagem.titulo,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 19,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viagem.destino,
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 15, color: Colors.blue.shade400),
                                SizedBox(width: 4),
                                Text(
                                  "De ${viagem.dataInicio.day}/${viagem.dataInicio.month}/${viagem.dataInicio.year} até ${viagem.dataFim.day}/${viagem.dataFim.month}/${viagem.dataFim.year}",
                                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await _editarViagem(viagem);
                            } else if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Remover viagem'),
                                  content: Text('Tem certeza que deseja remover esta viagem?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, true),
                                      child: Text('Remover', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await _removerViagem(viagem.id!);
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Remover'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViagemDetalheScreen(viagemId: viagem.id!),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adicionar Nova Viagem",
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddViagemScreen()),
          );
          await _loadViagens();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
