import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthWidget extends StatefulWidget {
  const BiometricAuthWidget({Key? key}) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Não autenticado';

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Autentique-se para acessar',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      setState(() {
        _authorized = authenticated ? 'Autenticado com sucesso!' : 'Falha na autenticação';
      });
    } catch (e) {
      setState(() {
        _authorized = 'Erro ao autenticar: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Autenticação biométrica'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_authorized),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Autenticar'),
              )
            ],
          ),
        ));
  }
}
