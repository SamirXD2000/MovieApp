class Cast
{
  List<Actor> actores = new List();

  //Metodo constructor
  Cast.fromJsonList(List<dynamic> jsonList)
  {
    if (jsonList == null) return;

    jsonList.forEach((item)
    {
      final actor = Actor.fromJsonMap(item);
      actores.add(actor);
    });
  }
}

class Actor
{
  int castId;
  String character;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  //Metodo para recibir la información
                  //Map<id,39484>
  Actor.fromJsonMap(Map<String, dynamic> json){
    castId = json['cast_id'];
    character = json['character'];
    gender = json['gender'];
    id = json['id'];
    name = json['name'];
    order = json['order'];
    profilePath = json['profile_path'];
  }

  getPosterFoto()
  {
    if (profilePath == null)
    {
      return 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Icon_None.svg/1200px-Icon_None.svg.png';
    }
    else
    {
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }
  }
}