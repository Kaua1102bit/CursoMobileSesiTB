import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/models/pet_model.dart';
import 'package:sqflite/sqflite.dart';

class PetShopDBHelper{
  static Database? _database; //obj para criar conexões
  // transformando a classe em singleton ->
  // não permite instanciar outro objeto enquanto um objeto estiver já ativo
  static final PetShopDBHelper _instance = PetShopDBHelper._internal();

  // construtor do singleton
  PetShopDBHelper._internal(); 
  factory PetShopDBHelper(){
    return _instance;
  }

  Future<Database> get database async{
    if(_database != null){
      return _database!;//se o banco já existe , retorna ele mesmo
    }
    //se não existe - inicia a conexão
    _database = await _initDatabase();
    return _database!;
  }
  
  get consulta => null;

  Future<Database> _initDatabase() async{
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath,"petshop.db"); //caminho do banco de Dados

    return await openDatabase(
      path,
      version:1,
      onCreate: (db, version) async{
        await db.execute(
          """CREATE TABLE IF NOT EXISTS pets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            raca TEXT NOT NULL,
            nome_dono TEXT NOT NULL,
            telefone_dono TEXT NOT NULL
            )
            """);
           print("banco pets criado");

            // cria a tabela consultas
        await db.execute( '''
            CREATE TABLE IF NOT EXISTS consultas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pet_id INTEGER NOT NULL,
            data_hora TEXT NOT NULL,
            tipo_servico TEXT NOT NULL,
            observacoes TEXT NOT NULL,
            FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE
        ''');
      },
    );
  }


  //MÉTODOS CRUD PARA pets
  Future<int> insertPet(Pet pet) async{
    final db = await database;
    return await db.insert("pets", pet.toMap());//retorna o ID do pet
  }

  Future<List<Pet>> getPets() async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query("pets"); // recebe todos os pets cadastros
    //converter em objetos
    return maps.map((e)=>Pet.fromMap(e)).toList();
    // adiciona elem por elem na lista já convertido em obj
  }

  Future<Pet?> getPetById(int id) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query( //faz a busca no BD
      "pets",where: "id=?",whereArgs: [id]); // A partir do ID solicitado
    // Se Encontrado
    if(maps.isNotEmpty){
      return Pet.fromMap(maps.first); //cria o obj com 1º elementos da list
    }else{
      null;
    }
  }

  Future<int> deletePet(int id) async{
    final db = await database;
    return await db.delete("pets", where: "id=?", whereArgs: [id]); 
    // deleta o pet da tabela que tenha o id passado pelo parametro
  }
 
  // métodos CRUDs para consultas

  Future<int> insertConsulta(Consulta Consulta) async{
    final db = await database;
    return await db.insert("consultas", consulta.toMap());
  }

  Future<List<Consulta>> getConsultaForPet(int petId) async {
    final db = await database;
    //Consulta por pet especifico
    final List<Map<String,dynamic>> maps = await db.query(
      "consulta",
      where: "pet_id = ?",
      whereArgs: [petId],
      orderBy: "data_hora ASC" //ordena pela data/hora
    );
    //converter a map para obj
    return maps.map((e) => Consulta.fromMap(e)).toList();
  }

  Future<int> deleteConsulta(int id) async {
    final db = await database;
    //delete pelo ID
    return await db.delete("consulta", where: "Id=?", whereArgs: [id]);
  }

  
}