import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = ["Fast and Furious", "The Batman", "Super-Man", "The Nun"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cine Favorite"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, i) => ListTile(
          leading: const Icon(Icons.movie),
          title: Text(favoritos[i]),
          trailing: const Icon(Icons.favorite, color: Color.fromARGB(255, 1, 26, 255)),
        ),
      ),
    );
  }
}
