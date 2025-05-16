import 'package:flutter/material.dart';
import 'package:sa_petshop/controllers/pets_controller.dart';
import 'package:sa_petshop/models/pet_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final PetsController _petsController = PetsController();

  List<Pet> _pets = [];
  bool _isLoanding = true; // enquanto carrega o banco

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async{
     setState(() {
       _isLoanding = true;
     });
    try {
      _pets = _petsController.fetchPets();
    } catch (Error) { //pega o erro do sistema
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Exception: $Error")));
    } finally { // 
      setState(() {
        _isLoanding = false;
      });
    }
  }

  @override // buildar a tela
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Meus Pets")),
      body: _isLoanding ? Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (context,index) {
          final pet = _pets[index];
          return ListTile(
            title: Text(pet.nome),
            subtitle: Text(pet.raca),
            onTap: () async {
              //navegação para a página de detalhes do pet

            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          tooltip: "Adicionar Novo Pet",
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPetScreen()));
          },
          child: Icon(Icons.add),
          ),
    );
  }

}