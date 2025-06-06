import 'package:sapetshop/database/db_helper.dart';
import 'package:sapetshop/models/consulta_model.dart';

class EntradasDiariasController {
  final DiarioViagemDBHelper _dbHelper = DiarioViagemDBHelper();

  Future<List<EntradaDiaria>> getEntradasByViagem(int viagemId) async {
    return await _dbHelper.getEntradasForViagem(viagemId);
  }

  Future<int> insertEntrada(EntradaDiaria entrada) async {
    return await _dbHelper.insertEntradaDiaria(entrada);
  }

  Future<int> deleteEntrada(int id) async {
    return await _dbHelper.deleteEntradaDiaria(id);
  }
}