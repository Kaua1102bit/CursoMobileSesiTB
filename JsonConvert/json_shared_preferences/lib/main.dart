import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool temaEscuro = false;
  String nomeUsuario = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarPreferencias();
  }

  Future<void> carregarPreferencias() async {
    // conecta com as shared preferences e busca as informações armazenadas
    final prefs = await SharedPreferences.getInstance();
    // recupera as informações do sharedPreferences e armazena como uma string (Json)
    String? jsonString = prefs.getString('config');
    if (jsonString != null) {
      // transformo Json em Map -- DECODE
      Map<String, dynamic> config = json.decode(jsonString);
      setState(() {
        // pega as informações de acordo com a chave armazenada
        temaEscuro = config['temaEscuro'] ?? false;
        nomeUsuario = config['nome'] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App de configurações",
      // operador ternário
      theme: temaEscuro ? ThemeData.dark() : ThemeData.light(),
      home: ConfigPage(),
    );
  }
}
