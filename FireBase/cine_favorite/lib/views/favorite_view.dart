import 'dart:io';
import 'dart:ui';

import 'package:cine_favorite/controllers/movie_firestore_controller.dart';
import 'package:cine_favorite/models/movie.dart';
import 'package:cine_favorite/views/search_movie_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  // atributo
  final _movieFireStoreController = MovieFirestoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filmes Favoritos"),
        actions: [
          IconButton(
              onPressed: FirebaseAuth.instance.signOut,
              icon: Icon(Icons.logout))
        ],
      ),
      //criar uma gridView com os filmes favoritos
      body: StreamBuilder<List<Movie>>(
          stream: _movieFireStoreController.getFavoriteMovies(),
          builder: (context, snapshot) {
            //se deu erro
            if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao Carregar a Lista de Favoritos"),
              );
            }
            // enquanto carrega a lista
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            //quando a lista esta vazia
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text("Nenhum Filme Adicionado Aos Favoritos"),
              );
            }
            //a construção da lista
            final favoriteMovies = snapshot.data!;
            return Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    //criar um obj de Movie
                    final movie = favoriteMovies[index];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onLongPress: () async {
                                // colocar um alert de confirmação
                                _movieFireStoreController
                                    .removeFavoriteMovie(movie.id);
                              },
                              child: Image.file(
                                File(movie.posterPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // titulo do filme
                          Center(
                            child: Text(movie.title),
                          ),
                          // RatingBar ajustado com SizedBox para ocupar toda a largura
                          SizedBox(
                            width: double.infinity,
                            child: RatingBar(
                              initialRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              ratingWidget: RatingWidget(
                                full: const Icon(Icons.star, color: Colors.orange),
                                half: const Icon(Icons.star_half, color: Colors.orange),
                                empty: const Icon(Icons.star_outline, color: Colors.orange),
                              ),
                              onRatingUpdate: (value) {
                                setState(() {
                                  var _ratingValue = value;
                                });
                              },
                            ),
                          ),
                          // botão de deletar
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Remover Filme"),
                                  content: Text(
                                      "Tem certeza que deseja remover '${movie.title}' dos favoritos?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        "Remover",
                                        style:
                                            TextStyle(color: Colors.redAccent),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                _movieFireStoreController
                                    .removeFavoriteMovie(movie.id);
                              }

                            },
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => SearchMovieView())),
        child: Icon(Icons.search),
      ),
    );
  }
}
