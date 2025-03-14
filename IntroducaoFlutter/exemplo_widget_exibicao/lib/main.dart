import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  //widget build
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(title: Text("Exemplo Widget Exibição")),
        body:Center(
          child: Column(
            children: [
              Text("Um Texto Qualquer",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                letterSpacing: 2
              )
              ),
              Image.network("https://imgs.search.brave.com/lZrUPB2wni_EXXaJe548v9knghEmf9KZhgMfaoUslaY/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9zdG9y/YWdlLmdvb2dsZWFw/aXMuY29tL2Ntcy1z/dG9yYWdlLWJ1Y2tl/dC80ZmQ1NTIwZmUy/OGViZjgzOTE3NC5z/dmc",
              width: 200,
              height: 200,
              fit: BoxFit.cover,),
              Image.asset("assets/img/einstein.png",
              width: 200,
              height: 200,
              fit: BoxFit.cover),
              Icon(Icons.star,
              size: 100,
              color: Colors.yellow,)
            ],
          ),
        )
      )
    );
  }
}