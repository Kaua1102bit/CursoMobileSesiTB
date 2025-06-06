import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/viagens_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/screens/add_viagem_screen.dart';
import 'package:sapetshop/screens/viagem_detalhe_screen.dart';

class HomeScreen extends StatefulWidget {
  // controla as mudanas de state
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ViagensController _viagensController = ViagensController();

  List<Viagem> _viagens = [];
  bool _isLoading = true; // enquanto carrega o banco
 
  @override
  void initState() {
    // TODO: implement initState
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
      //pega o erro do sistema
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Exception: $erro")));
    } finally {
      //execução obrigatória
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override //buildar a tela
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Viagens")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _viagens.isEmpty
              ? Center(
                  child: Text(
                    "Nenhuma viagem cadastrada ainda.",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  itemCount: _viagens.length,
                  itemBuilder: (context, index) {
                    final viagem = _viagens[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Icon(Icons.flight_takeoff, color: Colors.blue.shade700),
                        ),
                        title: Text(
                          viagem.titulo,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viagem.destino,
                              style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "De ${viagem.dataInicio.day}/${viagem.dataInicio.month}/${viagem.dataInicio.year} até ${viagem.dataFim.day}/${viagem.dataFim.month}/${viagem.dataFim.year}",
                              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue.shade400),
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
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
