import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sapetshop/models/consulta_model.dart';
import 'package:sapetshop/models/viagem_model.dart';
import 'package:sqflite/sqflite.dart';

class DiarioViagemDBHelper {
  static Database? _database;
  static final DiarioViagemDBHelper _instance = DiarioViagemDBHelper._internal();

  DiarioViagemDBHelper._internal();
  factory DiarioViagemDBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final _dbPath = await getDatabasesPath();
    final path = join(_dbPath, "diarioviagem.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE IF NOT EXISTS viagens(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            destino TEXT NOT NULL,
            data_inicio TEXT NOT NULL,
            data_fim TEXT NOT NULL,
            descricao TEXT NOT NULL
          )
        """);
        await db.execute("""
          CREATE TABLE IF NOT EXISTS entradas_diarias(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            viagem_id INTEGER NOT NULL,
            data TEXT NOT NULL,
            texto TEXT NOT NULL,
            foto_path TEXT,
            FOREIGN KEY (viagem_id) REFERENCES viagens(id) ON DELETE CASCADE
          )
        """);
      },
    );
  }

  // CRUD para Viagem
  Future<int> insertViagem(Viagem viagem) async {
    final db = await database;
    return await db.insert("viagens", viagem.toMap());
  }

  Future<int> updateViagem(Viagem viagem) async {
    final db = await database;
    return await db.update(
      "viagens",
      viagem.toMap(),
      where: "id = ?",
      whereArgs: [viagem.id],
    );
  }

  Future<List<Viagem>> getViagens() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("viagens");
    return maps.map((e) => Viagem.fromMap(e)).toList();
  }

  Future<Viagem?> getViagemById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "viagens",
      where: "id=?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Viagem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteViagem(int id) async {
    final db = await database;
    return await db.delete("viagens", where: "id=?", whereArgs: [id]);
  }

  // CRUD para EntradaDiaria
  Future<int> insertEntradaDiaria(EntradaDiaria entrada) async {
    final db = await database;
    return await db.insert("entradas_diarias", entrada.toMap());
  }

  Future<List<EntradaDiaria>> getEntradasForViagem(int viagemId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "entradas_diarias",
      where: "viagem_id = ?",
      whereArgs: [viagemId],
      orderBy: "data ASC",
    );
    return maps.map((e) => EntradaDiaria.fromMap(e)).toList();
  }

  Future<int> deleteEntradaDiaria(int id) async {
    final db = await database;
    return await db.delete("entradas_diarias", where: "id=?", whereArgs: [id]);
  }
}