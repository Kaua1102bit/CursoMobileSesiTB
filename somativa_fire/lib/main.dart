import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Importar as telas (você deve criar esses arquivos)
import 'views/splash_view.dart';
import 'views/map_view.dart';
import 'views/biometria_auth_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App com Firebase, Maps e Biometria',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        '/home': (context) => const HomeView(),
        '/map': (context) => const MapView(),
        '/biometric': (context) => const BiometricAuthWidget(),
      },
    );
  }
}

// Tela inicial para testes e navegação
class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Testes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/map'),
              child: const Text('Abrir Mapa'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/biometric'),
              child: const Text('Autenticação Biométrica'),
            ),
          ],
        ),
      ),
    );
  }
}
