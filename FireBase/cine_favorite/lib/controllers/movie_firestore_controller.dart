//gerencia o relacionamento do modelo com o fireStore (firebase)

import 'dart:io';

import 'package:cine_favorite/models/movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MovieFirestoreController {
  //atributos
  final _auth = FirebaseAuth.instance; //constroller do firebase 
  final _db = FirebaseFirestore.instance;

  //criar um método para pegar o usuário logado
  User? get currentUser => _auth.currentUser;

  //método para pegar os filmes da coleção de favoritos
  //Stream => criar um ouvinte(listener => pegar a lista de favoritos, sempre que for modificada
  Stream<List<Movie>> getFavoriteMovies() {
  if (currentUser == null) return Stream.value([]);

  return _db
      .collection("usuarios")
      .doc(currentUser!.uid)
      .collection("favorite_movies")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Movie.fromMap(doc.data(), doc.id)).toList());
}


  //path e path_provider (bibliotecas que permitem acesso as pastas do dispositivo)
  //adicionar um filme a lista de favoritos
  void addFavoriteMovie(Map<String,dynamic> movieData) async{
    //verificar se o filme tem poster (imagem da capa)
    if(movieData["poster_path"] == null) return; //se filme não tiver capa não continua

    //vou armazenar a capa do filme no dispositivo
    //baixando a imagem da internet
    final imageUrl = "https://image.tmdb.org/t/p/w500${movieData["poster_path"]}"; 
    //https://image.tmdb.org/t/p/w500/6vbxUh6LWHGhfuPI7GrimQaXNsQ.jpg
    final responseImg = await http.get(Uri.parse(imageUrl));

    //aramazenar a imagem no diretório do aplicativo
    final imgDir = await getApplicationDocumentsDirectory();
    //baixando a imagem para o aplicativo
    final file = File("${imgDir.path}/${movieData["id"]}.jpg");
    await file.writeAsBytes(responseImg.bodyBytes);

    // Criar o OBJ do Filme
    final movie = Movie(
      id: movieData["id"], 
      title: movieData["title"], 
      posterPath: file.path.toString());
    
    //adicionar o filme no firestore
    await _db
    .collection("usuarios")
    .doc(currentUser!.uid)
    .collection("favorite_movies")
    .doc(movie.id.toString()) //cio um obj com o ID igual ao ID do TMDB
    .set(movie.toMap());
  }

  //delete
  void removeFavoriteMovie(int movieId) async{
    await _db.collection("usuarios").doc(currentUser!.uid)
    .collection("favorite_movies").doc(movieId.toString()).delete();
    //deleta o filme da lista e favoritos a partir do ID do Filme

    // deletar a imagem o filme
    final imagemPath = await getApplicationDocumentsDirectory();
    final imagemFile = File("${imagemPath.path}/$movieId.jpg");
    try {
      await imagemFile.delete();
    } catch (e) {
      print("Erro ao deletar imagem: $e");
    }
  }

  //update (modificar a nota)
  void updateMovieRating(int movieId, double rating) async{
    await _db.collection("usuarios").doc(currentUser!.uid)
    .collection("favorite_movies").doc(movieId.toString())
    .update({"rating":rating});
  }

  // aqui implementei de verdade 👇
  Future<void> deleteFavoriteMovie(int id) async {
    await _db
        .collection("usuarios")
        .doc(currentUser!.uid)
        .collection("favorite_movies")
        .doc(id.toString())
        .delete();

    // deletar imagem local também
    final imgDir = await getApplicationDocumentsDirectory();
    final file = File("${imgDir.path}/$id.jpg");
    if (await file.exists()) {
      await file.delete();
    }
  }
}
