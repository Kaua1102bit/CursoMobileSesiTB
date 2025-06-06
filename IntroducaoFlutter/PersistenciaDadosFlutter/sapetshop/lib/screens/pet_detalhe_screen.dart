// tela de detalhes do pet 
import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/consultas_controller.dart';
import 'package:sapetshop/controllers/pets_controller.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/models/pet_model.dart';
import 'package:sapetshop/screens/add_consulta_screen.dart';

class PetDetalheScreen extends StatefulWidget {
    final int petId; // Receber o Id do Pet

    const PetDetalheScreen({
      Key? key, required this.petId
    }); // construtor para pear o Id do PET

    @override
  State<StatefulWidget> createState() {
    return _PetDetalheScreenState();
  }

}

class _PetDetalheScreenState extends State<PetDetalheScreen> { //build da tela
   final PetsController _controllerPets = PetsController();
   final ConsultasController _controllerConsultas = ConsultasController();
   bool _isLoading = true;

   Pet? pet; //inicialmente pode ser nulo

   List<Consulta> _consultas = [];

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPetConsultas();
  }

  Future<void> _loadPetConsultas()async {
    setState(() async {
      try {
        pet = await _controllerPets.findPetById(widget.petId);
      _consultas = await _controllerConsultas.getConsultasByPet(widget.petId);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exception $e'),
          ),
        );
      } finally{
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do Pet"),),
      body:  _isLoading
          ? Center(child: CircularProgressIndicator(),)
          : _consultas.length == 0 // senão tiver pet criado -- erro 
          ? const Center(child: Text("Erro ao carregar o pet"),)
          :Padding( // constroí as info do pet
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: ${pet!.nome}"),
                Text("Raça: ${pet!.raca}"),
                Text("Dono: ${pet!.nomeDono}"),
                Text("Telefone: ${pet!.telefoneDono}"),
                Divider(),
                Text("Consultas:"),
                _consultas.length == 0 // verifica se tem consultas
                ? Center(child: Text("Não Existe consultas Cadastradas"),)
                : Expanded(child: ListView.builder( // prrenche as lista com as consultas do pet 
                  itemCount: _consultas.length,
                  itemBuilder: (context,index){
                    final consulta = _consultas[index];
                    return ListTile(
                      title: Text(consulta.tipoServico),
                      subtitle: Text(consulta.dataHoraFormata),
                      trailing: IconButton(
                        onPressed: ()=>_deleteConsulta(consulta.id!),
                        icon: Icon(Icons.delete)),
                        //onTap -> função para ver os detalhes da consulta
                    );
                  }))
              ],
            ),
          ),
      floatingActionButton: FloatingActionButton(
      onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>AddConsultaScreen(petId: widget.petId)))),
    );
  }

  void _deleteConsulta(int consultaId) async {
    await _controllerConsultas.deleteConsulta(consultaId);
    _loadPetConsultas();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Consulta deleytada com sucesso !!!")));
  }
}