import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/consultas_controller.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/screens/pet_detalhe_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddEntradaScreen extends StatefulWidget {
  final int viagemId;

  const AddEntradaScreen({super.key, required this.viagemId});

  @override
  State<StatefulWidget> createState() {
    return _AddEntradaScreenState();
  }
}

class _AddEntradaScreenState extends State<AddEntradaScreen> {
  final _formKey = GlobalKey<FormState>();
  final EntradasDiariasController _controllerEntrada = EntradasDiariasController();

  String texto = "";
  DateTime _selectedDate = DateTime.now();
  String? fotoPath;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        fotoPath = pickedFile.path;
      });
    }
  }

  Future<void> _salvarEntrada() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final novaEntrada = EntradaDiaria(
        viagemId: widget.viagemId,
        data: _selectedDate,
        texto: texto,
        fotoPath: fotoPath,
      );

      try {
        await _controllerEntrada.insertEntrada(novaEntrada);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Entrada adicionada com sucesso!")),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViagemDetalheScreen(viagemId: widget.viagemId)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao adicionar entrada: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Entrada Diária"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Adicione um momento à sua viagem",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Text("Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}")),
                  TextButton.icon(
                    onPressed: () => _selectDate(context),
                    icon: Icon(Icons.calendar_today),
                    label: const Text("Selecionar Data"),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: "Texto do Diário", prefixIcon: Icon(Icons.edit)),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? "Por favor, insira o texto" : null,
                onSaved: (value) => texto = value!,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _selecionarFoto,
                    icon: Icon(Icons.photo),
                    label: Text("Selecionar Foto"),
                  ),
                  const SizedBox(width: 16),
                  if (fotoPath != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(fotoPath!),
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _salvarEntrada,
                icon: Icon(Icons.save),
                label: const Text("Salvar Entrada"),
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