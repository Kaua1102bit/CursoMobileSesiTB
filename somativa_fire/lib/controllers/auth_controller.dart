import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Registrar novo usuário
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // erro
    }
  }

  // Fazer login
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Fazer logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Verificar se há usuário logado
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
