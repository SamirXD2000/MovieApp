import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{
  String seleccion = '';

  final peliProvider = new PeliculasProvider();

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        
      }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    if (query.isEmpty)
    {
      return Container();
    }
    return FutureBuilder(
      future: peliProvider.buscarMovie(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot)
      {
        if(snapshot.hasData)
        {
          final peliculassnapshot = snapshot.data; //La lista de peliculas
          return ListView(
            children: peliculassnapshot.map((peliculamodel)
            {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'), 
                  image: NetworkImage(peliculamodel.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(peliculamodel.title),
                subtitle: Text(peliculamodel.originalTitle),
                onTap: () {
                  close(context, null);
                  peliculamodel.realId = '';
                  Navigator.pushNamed(context, 'detalle', arguments: peliculamodel);
                },
              );
            }).toList(),
          );
        }
        else
        {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }




}