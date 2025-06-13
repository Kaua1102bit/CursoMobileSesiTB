//formulario para adiconar nova viagem

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/pets_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/screens/home_screen.dart';

class AddViagemScreen extends StatefulWidget {
  @override
  State<AddViagemScreen> createState() => _AddViagemScreenState();
}
 
class _AddViagemScreenState extends State<AddViagemScreen> {
  final _formKey = GlobalKey<FormState>(); //chave para o Formulário
  final _viagensController = ViagensController();

   String _titulo = "";
   String _destino = "";
   String _descricao = "";
   DateTime _dataInicio = DateTime.now();
   DateTime _dataFim = DateTime.now();

  Future<void> _selecionarDataInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataInicio = picked;
      });
    }
  }

  Future<void> _selecionarDataFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataFim,
      firstDate: _dataInicio,
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dataFim = picked;
      });
    }
  }

  Future<void> _salvarViagem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final novaViagem = Viagem(
        titulo: _titulo,
        destino: _destino,
        dataInicio: _dataInicio,
        dataFim: _dataFim,
        descricao: _descricao,
      );
      try {
        await _viagensController.addViagem(novaViagem);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Nova Viagem"),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Título da Viagem"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => _titulo = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Destino"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => _destino = value!,
              ),
              Row(
                children: [
                  Expanded(child: Text("Início: ${_dataInicio.day}/${_dataInicio.month}/${_dataInicio.year}")),
                  TextButton(
                    onPressed: () => _selecionarDataInicio(context),
                    child: Text("Selecionar"),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text("Fim: ${_dataFim.day}/${_dataFim.month}/${_dataFim.year}")),
                  TextButton.icon(
                    onPressed: () => _selecionarDataFim(context),
                    icon: Icon(Icons.flag),
                    label: Text("Selecionar"),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Descrição"),
                maxLines: 3,
                onSaved: (value) => _descricao = value!,
              ),
              ElevatedButton(onPressed: _salvarViagem, child: Text("Salvar"))

            ],
          )),
        ),
    );
  }
}

