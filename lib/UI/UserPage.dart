import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Affichage.dart';
import 'package:flutter/material.dart';
import 'Categories.dart';
import '../Util/Posts.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~9280199540';

class UserPage extends StatefulWidget{

  String keys;
  UserPage(this.keys);

  @override
  State <StatefulWidget> createState() {
    return _UserPageState(keys);
  }
}

class _UserPageState extends State<UserPage>{

  List<Posts> postsList = [];
  List<Categories> categories = [];
  String key;
  String _value;
  String cle;
  _UserPageState(this.key);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    restore();

    FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);

    _firebase();
   
  }


    restore() async{
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      key = (sharedPrefs.getString('key') ?? false);
    });}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Vos publications"),
      ),

      body: new Container(
        child: postsList.length == 0 ? new Center(
          child: new Column(
            children: <Widget>[
              _getListData(),
              new SizedBox(height: 10.0,),
              Text("En cours de chargement ...")
            ]
          )
        ) 
        : new Container(
          child:
          new Column(
            children: <Widget>[
              _getListData(),
              new SizedBox(height: 10.0,),
              new Expanded(
                child: 
                  new ListView.builder(
                      itemCount: postsList.length,
                      itemBuilder: (_, index){
                        return PostsUI(
                          postsList[index].image,
                          postsList[index].description,
                          postsList[index].date,
                          postsList[index].time,
                          postsList[index].key,
                          postsList[index].prix,
                          postsList[index].contact,
                          postsList[index].categorie,
                          postsList[index].vendue,
                          postsList[index].cle,
                          postsList[index].images,
                      );
                    },
                  ),
              )
            ],
          )
        )
      ),
    );
  }

Widget _getListData() {
    return new Container(
      height:75.0,
      child: new ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index){
          return new GestureDetector(
            child: new Card(
                elevation: 5.0,
                child: new Container(
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width / 3,
                alignment: Alignment.center,
                child:
                new Stack(children: <Widget>[
                  new Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(image: NetworkImage(categories[index].lien), fit: BoxFit.cover)
                    )
                  ),
                  
                  new Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  )
                  ),

                  new Center(child: new Text(
                    categories[index].nom,
                    style: new TextStyle(
                      color: Colors.white
                    ),
                    textScaleFactor: 1.5,
                  ),),

                ],
                ) 
              ),
            ),
            onTap: () {
              _value = categories[index].nom;
              _firebase();
            },
          );
        },
      )
    );
  }

    _firebase(){
    postsList.clear();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference();
    Query query;
    if(_value == "Tous" || _value == null){
      query = postsRef.child("Posts_2");
    } else{
      query = postsRef.child("Posts_2").orderByChild("categorie").equalTo(_value);
    }

    query.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;


      postsList.clear();

      for(var individualKey in KEYS){
        Posts posts = new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
          DATA[individualKey]['key'],
          DATA[individualKey]['prix'],
          DATA[individualKey]['contact'],
          DATA[individualKey]['categorie'],
          DATA[individualKey]['vendue'],
          individualKey.toString(),
          DATA[individualKey]['images']
        );
      if (key == DATA[individualKey]['key']){
        postsList.add(posts);
      }
    }

    setState(() {
    });
    });

    categories.clear();

    Query cat = postsRef.child("Categories");

    cat.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      categories.clear();

      for(var individualKey in KEYS){
        Categories categorie = new Categories(
          DATA[individualKey]['nom'],
          DATA[individualKey]['lien']
        );

        categories.add(categorie);
      }

      setState((){
        print(categories.length.toString());
      });
    });
  }

    Widget icons(bool vendue){
      if (vendue){
        return new Icon(
        Icons.close,
        size: 30.0,
        color: Colors.red,
    );
      } else{
        return new Icon(
        Icons.check,
        size: 30.0,
        color: Colors.green,
    );
      }
    }

    Widget PostsUI(String image, String description, String date, String time, String key, String prix, String contact, String categorie, bool vendue, String cle, String images){
    String _etat, specification;
    if (vendue){
      _etat = "Non Disponible";
      specification = "SPECIFIER DISPONIBLE";
    } else{
      _etat = "Disponible";
      specification = "SPECIFIER INDISPONIBLE";
    };

    return new Card(
          elevation: 5.0,
           margin: EdgeInsets.all(10.0),
          child: new Container(
            padding: new EdgeInsets.all(7.0),

            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      icons(vendue),
                      new SizedBox(width: 5.0),
                      new Text(
                        _etat,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],),

                    new Text(
                      prix,
                      textScaleFactor: 1.5,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height:10.0),

                new GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context){
                        return new AffichageImage(image);
                      })
                    );
                  },
                  child: new Image.network(
                    image,
                    height: 250.0,
                    width: MediaQuery.of(context).size.width,
                    fit:BoxFit.cover
                  ),
                ),

                SizedBox(height: 10.0,),

                new Text(
                  description,
                  style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0
                          ),
                  textAlign: TextAlign.center,
                ),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      icons(vendue),
                      new FlatButton(
                      child: Row(children: <Widget>[
                        new Text(
                          specification,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                          ),
                          textAlign: TextAlign.left,
                        ),
                    ],),
                      onPressed: (){
                        setState(() {
                          DatabaseReference postsRef = FirebaseDatabase.instance.reference();
                          if(vendue){
                            postsRef.child("Posts_2").child(cle).child("vendue").set(false);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return new UserPage(this.key);
                                  })
                              );
                          } else{
                            postsRef.child("Posts_2").child(cle).child("vendue").set(true);
                            Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return new UserPage(this.key);
                                  })
                              );
                          }
                        });
                      },
                    )
                    ],),

                    new FlatButton(
                      onPressed: (){
                        deleteImage("Post Images/" + images, cle);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                            return new UserPage(this.key);
                          })
                        );
                      },
                      child: new Row(
                        children:<Widget>[
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          SizedBox(width:5.0),
                          Text(
                            "Supprimer",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          )
                        ]
                      )
                    )
                  ],
                ),
              ],
            ),
          ),  
        );
  }

  Future deleteImage(String imageFileName, String cle) async {
    DatabaseReference postsRef = FirebaseDatabase.instance.reference();
    postsRef.child("Posts_2").child(cle).remove();
    final FirebaseStorage firebaseStorageRef = FirebaseStorage(storageBucket: 'gs://dealtout-cb535.appspot.com/');
    try {
      await firebaseStorageRef.ref().child(imageFileName).delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}