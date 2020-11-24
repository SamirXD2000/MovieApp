import 'dart:async';
import 'dart:convert';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider 
{
  //String _apikey = "6a9e8afcb8fa71ecc6a592b2b00b3e1c";
  //String _url = "api.themoviedb.org";
  //String _language = "es-ES";
  int _popularesPage = 0;

  List<Pelicula> _populares = new List();
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams()
  {
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta(String url) async
  {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;
  }


  Future<List<Pelicula>> getEnCines() async
  {
    final url = "https://api.themoviedb.org/3/movie/now_playing?api_key=6a9e8afcb8fa71ecc6a592b2b00b3e1c&language=es-MX&page=1";

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    return peliculas.items;

  }

  Future<List<Pelicula>> getPopulares() async
  {
    _popularesPage++;
    String eri = _popularesPage.toString();
    final url = "https://api.themoviedb.org/3/movie/popular?api_key=6a9e8afcb8fa71ecc6a592b2b00b3e1c&language=es-MX&page=$eri";
    //final resp = await http.get(url);
    //final decodedData = json.decode(resp.body);

    //final peliculas = new Peliculas.fromJsonList(decodedData['results']);

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async 
  {
    final url = "https://api.themoviedb.org/3/movie/$peliId/credits?api_key=6a9e8afcb8fa71ecc6a592b2b00b3e1c";
    //Ejecutar el htto get de la url
    final resp = await http.get(url); //await sirve para esperar la respusta
    //Almacenar la respusta en un mapa(es un mapa)
    final decodedData = json.decode(resp.body);
    //Sacas cast del json raw
    final cast = new Cast.fromJsonList(decodedData['cast']);
    //retornas la lista de actores
    return cast.actores;
  }


  
  Future<List<Pelicula>> buscarMovie(String querysita) async
  {
    final url = "https://api.themoviedb.org/3/search/movie?api_key=6a9e8afcb8fa71ecc6a592b2b00b3e1c&language=es-MX&query=$querysita&page=1&include_adult=false";

    return await _procesarRespuesta(url);

  }
}