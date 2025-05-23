import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sapetshop/controllers/consultas_controller.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/screens/pet_detalhe_screen.dart';

class AddConsultaScreen extends StatefulWidget{
  final int petId; // recebe o pet Id da tela anterior

  const AddConsultaScreen({super.key, required this.petId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddConsultaScreenState();
  }
}

class _AddConsultaScreenState extends State<AddConsultaScreen> {
  final _formKey = GlobalKey<FormState>();
  final ConsultasController _controllerConsulta = ConsultasController();

  String tipoServico="";
  String observacao="";
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // método para seleção da data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // não permite selecionar data anterior a data atual
      lastDate: DateTime(2026));
      if (picked != null && picked != _selectedDate){
        setState(() {
          _selectedDate = picked;
        });
      }
  }

  //método para seleção de hora
  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
       initialTime: _selectedTime,
       );
       if(picked != null && picked != _selectedTime){
         setState(() {
           _selectedTime = picked;
         });
       }
  }

  //método para salvar a consulta
  Future<void> _salvarConsulta() async {
    if(_formKey.currentState!.validate()){
      final DateTime finalDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      //criar a consulta(obj)
      final newConsulta = Consulta(
        petId: widget.petId,
        dataHora: finalDateTime,
        tipoServico: tipoServico,
        observacao: observacao=="" ? null: observacao);
        _controllerConsulta.insertConsulta(newConsulta);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PetDetalheScreen(petId: widget.petId)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm'); // intl
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Consulta"),),
        body:Padding(
          padding: EdgeInsets.all(16),
          child: Form(child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Tipo de Serviço"),
                validator: (value) => value!.isEmpty ? "Por favor, insira um tipo de serviço":null,
                onSaved: (value) => tipoServico = value!,
              ),
              Row(
                children: [
                  Expanded(child: Text("Data: ${dateFormatter.format(_selectedDate)}")),
                  TextButton(onPressed: () => _selectDate(context), child: Text("Selecionar Data")),
                ],
              ),
              Row(children: [
                Expanded(child: Text("Hora: ${timeFormatter.format(DateTime(0,0,0,_selectedTime.hour,_selectedTime.minute))}")),
                TextButton(onPressed: ()=> selectTime(context), child: Text("Selecionar Hora")),
              ],)
              TextFormField(
                decoration: InputDecoration(labelText: "Observação"),
                maxLines: 3,
                onSaved: (value) => observacao = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _salvarConsulta, child: Text("Agendar Consulta"))
            ],
          )),
        )
    );
  }
}