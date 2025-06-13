//formulario para adiconar nova viagem

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/viagens_controller.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sapetshop/screens/home_screen.dart'; 

class AddViagemScreen extends StatefulWidget {
  final Viagem? viagem;
  AddViagemScreen({this.viagem});

  @override
  State<AddViagemScreen> createState() => _AddViagemScreenState(); // Estado do formulário de adição de viagem
}
 
class _AddViagemScreenState extends State<AddViagemScreen> {
  final _formKey = GlobalKey<FormState>(); //chave para o Formulário
  final _viagensController = ViagensController();

   String _titulo = "";
   String _destino = "";
   String _descricao = "";
   DateTime _dataInicio = DateTime.now();
   DateTime _dataFim = DateTime.now();

   @override
   void initState() {
     super.initState();
     if (widget.viagem != null) {
       _titulo = widget.viagem!.titulo;
       _destino = widget.viagem!.destino;
       _descricao = widget.viagem!.descricao;
       _dataInicio = widget.viagem!.dataInicio;
       _dataFim = widget.viagem!.dataFim;
     }
   }

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
        id: widget.viagem?.id,
        titulo: _titulo,
        destino: _destino,
        dataInicio: _dataInicio,
        dataFim: _dataFim,
        descricao: _descricao,
      );
      try {
        if (widget.viagem == null) {
          await _viagensController.addViagem(novaViagem);
        } else {
          await _viagensController.updateViagem(novaViagem);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.viagem == null ? "Nova Viagem" : "Editar Viagem")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                widget.viagem == null ? "Planeje sua próxima viagem" : "Edite sua viagem",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: _titulo,
                decoration: InputDecoration(labelText: "Título da Viagem", prefixIcon: Icon(Icons.title)),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => _titulo = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _destino,
                decoration: InputDecoration(labelText: "Destino", prefixIcon: Icon(Icons.place)),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => _destino = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Text("Início: ${_dataInicio.day}/${_dataInicio.month}/${_dataInicio.year}")),
                  TextButton.icon(
                    onPressed: () => _selecionarDataInicio(context),
                    icon: Icon(Icons.calendar_today),
                    label: Text("Selecionar"),
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
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _descricao,
                decoration: InputDecoration(labelText: "Descrição", prefixIcon: Icon(Icons.description)),
                maxLines: 3,
                onSaved: (value) => _descricao = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarViagem,
                icon: Icon(Icons.save),
                label: Text(widget.viagem == null ? "Salvar" : "Atualizar"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}