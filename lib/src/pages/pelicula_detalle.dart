import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final Pelicula pelicula = ModalRoute.of(context).settings.arguments; //Todo esto para recibir argumentos

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList( //Un ListView
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),
                _posterTitulo(context, pelicula),
                SizedBox(height: 5.0,),
                Container(
                  child: Text('Sinopsis', style: Theme.of(context).textTheme.subtitle,),
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                ),
                _descripcion(pelicula),
                SizedBox(height: 10.0,),
                Container(
                  child: Text('Cast', style: Theme.of(context).textTheme.subtitle,),
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                ),
                _crearCasting(pelicula),
              ]
            ),
          ),
        ],
      )
    );
  }

  Widget _crearAppbar(Pelicula pelicula)
  {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        background: FadeInImage(
          placeholder: AssetImage('assets/img/loading.gif'), 
          image: NetworkImage(pelicula.getPoster2Img()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,),
        ),
        
        
      );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(children: <Widget>[
        Hero(
          tag: pelicula.realId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              height: 150.0,
              image: NetworkImage(pelicula.getPosterImg()),
            ),
          ),
        ),
        SizedBox(width: 20.0,),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
              Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis,),
              Row(
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                ],
              ),
            ],
          ),
        )
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }


  Widget _crearCasting(Pelicula pelicula)
  {
    final peliProvider = new PeliculasProvider();

    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()), 
      builder: (context, AsyncSnapshot<List> snapshot)
      {
        if(snapshot.hasData)
        {                   //lista completa de actores
          return _crearActoresPageView(snapshot.data);
        }
        else
        {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores)
    {
      return SizedBox(
        height: 200.0,
        child:PageView.builder(
          controller: PageController(
            initialPage: 1,
            viewportFraction: 0.3,
          ),
          itemCount: actores.length,
          itemBuilder: (context, i) => _actorTarjeta(actores[i]),
        )
      );
    }

  Widget _actorTarjeta(Actor actor)
  {
    return Container(
      child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(actor.getPosterFoto()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          actor.name,
          overflow: TextOverflow.ellipsis,
        ),
      ],
      ),
    );
  }
}