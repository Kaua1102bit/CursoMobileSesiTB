import 'package:sapetshop/database/db_helper.dart';
import 'package:sapetshop/models/viagem_model.dart';

class ViagensController {
  final DiarioViagemDBHelper _dbHelper = DiarioViagemDBHelper();

  Future<int> addViagem(Viagem viagem) async {
    return await _dbHelper.insertViagem(viagem);
  }

  Future<List<Viagem>> fetchViagens() async {
    return await _dbHelper.getViagens();
  }

  Future<Viagem?> findViagemById(int id) async {
    return await _dbHelper.getViagemById(id);
  }

  Future<int> deleteViagem(int id) async {
    return await _dbHelper.deleteViagem(id);
  }

  Future<int> updateViagem(Viagem viagem) async {
    return await _dbHelper.updateViagem(viagem);
  }
}
