import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mark.dart';

class MarkController {
  final _db = FirebaseFirestore.instance;

  // Adicionar uma nova marcação
  Future<void> addMark(String userEmail) async {
    final mark = Mark(
      id: '',
      userEmail: userEmail,
      timestamp: DateTime.now(),
    );

    await _db.collection('marcacoes').add(mark.toMap());
  }

  // Obter todas as marcações (stream para atualização em tempo real)
  Stream<List<Mark>> getMarks() {
    return _db
        .collection('marcacoes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Mark.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Excluir uma marcação (opcional)
  Future<void> deleteMark(String id) async {
    await _db.collection('marcacoes').doc(id).delete();
  }
}
