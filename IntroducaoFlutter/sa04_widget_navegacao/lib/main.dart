import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: { //3 telas de navegação do App
      "/": (context) => Scaffold(body: Center(child: Text("Home Page"))),
      "/cadastro": (context) => Scaffold(body: Center(child: Text("Cadastro Page"))),
      "/confirmacao": (context) => Scaffold(body: Center(child: Text("Confirmação Page"))),

    },
  ));
  }

  //quando era uma unica tela -> continuava na Class