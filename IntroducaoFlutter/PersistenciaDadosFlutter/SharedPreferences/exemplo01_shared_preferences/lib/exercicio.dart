import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Controladores para os campos de texto
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();

  // Variáveis para armazenar os dados
  String _nome = "";
  String _idade = "";
  String _corFavorita = "Azul"; // Cor favorita padrão
  Color _corDeFundo = Colors.blue; // Cor de fundo padrão

  // Lista de cores disponíveis
  final Map<String, Color> _cores = {
    "Azul": Colors.blue,
    "Vermelho": Colors.red,
    "Verde": Colors.green,
    "Amarelo": Colors.yellow,
  };

  @override
  void initState() {
    super.initState();
    _carregarDados(); // Carregar os dados salvos ao iniciar o app
  }

  // Método para carregar os dados do SharedPreferences
  void _carregarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nome = prefs.getString("nome") ?? "";
      _idade = prefs.getString("idade") ?? "";
      _corFavorita = prefs.getString("corFavorita") ?? "Azul";
      _corDeFundo = _cores[_corFavorita] ?? Colors.blue;
    });
  }

  // Método para salvar os dados no SharedPreferences
  void _salvarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_nomeController.text.trim().isNotEmpty &&
        _idadeController.text.trim().isNotEmpty) {
      await prefs.setString("nome", _nomeController.text);
      await prefs.setString("idade", _idadeController.text);
      await prefs.setString("corFavorita", _corFavorita);

      setState(() {
        _nome = _nomeController.text;
        _idade = _idadeController.text;
        _corDeFundo = _cores[_corFavorita] ?? Colors.blue;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dados salvos com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corDeFundo,
      appBar: AppBar(
        title: Text("Informações Pessoais"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _idadeController,
              decoration: InputDecoration(labelText: "Idade"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _corFavorita,
              onChanged: (String? novaCor) {
                setState(() {
                  _corFavorita = novaCor!;
                  _corDeFundo = _cores[_corFavorita]!;
                });
              },
              items: _cores.keys.map((String cor) {
                return DropdownMenuItem<String>(
                  value: cor,
                  child: Text(cor),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarDados,
              child: Text("Salvar Dados"),
            ),
            SizedBox(height: 20),
            Text(
              "Dados Salvos:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Nome: $_nome"),
            Text("Idade: $_idade"),
            Text("Cor Favorita: $_corFavorita"),
          ],
        ),
      ),
    );
  }
}