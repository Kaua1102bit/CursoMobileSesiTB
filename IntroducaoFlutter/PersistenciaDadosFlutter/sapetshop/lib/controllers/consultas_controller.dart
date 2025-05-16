class ConsultasController {
  final PetShopDBHelper _dbHelper = PetShopDBHelper();

  Future<List<Consulta>> getConsultasByPet() async{
    return await _dbHelper.getConsultaForPet(petId);
  }

  Future<int> insertConsulta(Consulta consulta) async{
    return await _dbHelper.insertConsulta(consulta);
  }

  Future<int> deleteConsulta(int id) async{
    return await _dbHelper.deleteConsulta(id);
  }
}