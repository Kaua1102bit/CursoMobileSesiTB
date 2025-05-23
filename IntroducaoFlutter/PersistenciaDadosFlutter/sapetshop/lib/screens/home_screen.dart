import 'package:flutter/material.dart';
import 'package:sapetshop/controllers/pets_controller.dart';
import 'package:sapetshop/models/pet_model.dart';
import 'package:sapetshop/screens/add_pet_screen.dart';
import 'package:sapetshop/screens/pet_detalhe_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final PetsController _petsController = PetsController();

  List<Pet> _pets = [];
  bool _isLoanding = true;
  
  get petId => null; // enquanto carrega o banco

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
      _pets = _petsController.fetchPets() as List<Pet>;
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
            onTap: () => Navigator.push(context,
             MaterialPageRoute(builder: (context)=> PetDetalheScreen(petId: petId!)))
           

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