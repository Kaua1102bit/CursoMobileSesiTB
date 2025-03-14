import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  // lista de imagens
  final List<String> imagens = [
    'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0',
    'https://images.unsplash.com/photo-1521747116042-5a810fda9664',
    'https://images.unsplash.com/photo-1504384308090-c894fdcc538d',
    'https://images.unsplash.com/photo-1518837695005-2083093ee35b',
    'https://images.unsplash.com/photo-1741290606668-c367b34d3d4a',
    'https://images.unsplash.com/photo-1741531472824-b3fc55e2ff9c',
    'https://images.unsplash.com/photo-1735090086720-1dd19b7e9b18',
    'https://images.unsplash.com/photo-1506619216599-9d16d0903dfd',
    'https://images.unsplash.com/photo-1494172961521-33799ddd43a5',
    'https://images.unsplash.com/photo-1741565697191-7924f3dd1fb4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeria de Imagens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 300, autoPlay: true),
              items: imagens.map((url) {
                return Container(
                  margin: EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(url, fit: BoxFit.cover, width: 1000),
                  ),
                );
              }).toList(),
            ),
            Expanded(
              // rolagem da tela
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Define 3 imagens por linha
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: imagens.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _mostrarImagem(context, imagens[index]),
                    child: Image.network(imagens[index], fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarImagem(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            child: Image.network(url),
          ),
        );
      },
    );
  }
}
