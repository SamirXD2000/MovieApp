import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart' as prefix0;
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';
class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar peliculas'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          })
        ],
        
      ),
      body: Container(
        child: Column(
          children: <Widget>[
              _swiperTarjetas(),
              _footer(context)
          ],
        )
      ),
    );
  }

  Widget _swiperTarjetas() 
  {
    
    //peliculasProvider.getEnCines();

    //return CardSwiper(peliculas: []);
    return FutureBuilder(
      future: PeliculasProvider().getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot)
      {
        if(snapshot.hasData)
        {
          return CardSwiper(peliculas: snapshot.data);
        }
        else{
          return Container(height: 400.0, child: Center(child: CircularProgressIndicator(),),);
        }
      },
    
    
    );
  }



  Widget _footer(BuildContext context)
  {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text('Populares', 
                    style: Theme.of(context).textTheme.subhead,
                  ),
            padding: EdgeInsets.only(left: 10.0),
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream, 
            builder: (BuildContext context, AsyncSnapshot snapshot)
            {
              if (snapshot.hasData)
              {
                return MovieHorizontal(peliculas: snapshot.data, siguientePagina: peliculasProvider.getPopulares,);
              }
              else
              {
                Center(child: CircularProgressIndicator());
              }
              return Container();
            }),
        ],
      ),
    );
  }
}