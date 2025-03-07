import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

 // Importando o pacote fluttertoast

void main() { // Método principal para rodar a aplicação
  runApp(MyApp()); // Construtor da classe principal
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Exemplo com Fluttertoast')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "OLá Mundo!!!", toastLength: Toast.LENGTH_SHORT);
            },
            child: Text("Mostrar Mensagem"),
          ),
        ),
      ),
    );
  }
}

