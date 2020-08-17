import 'package:DEALTOUT/ChatBody.dart';
import 'package:DEALTOUT/ListChat.dart';
import 'package:DEALTOUT/About.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Affichage.dart';
import 'Categories.dart';
import 'DialogBox.dart';
import 'PhotoUploadPage.dart';
import 'package:flutter/material.dart';
import 'Authentification.dart';
import 'Posts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'UserPage.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~9280199540';
const String AD_MOB_AD_ID = 'ca-app-pub-2474010233453501/8171808024';

class HomePage extends StatefulWidget{

  HomePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedOut;

  @override
  State <StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{


  List<Posts> postsList = [];
  List<Categories> categories = [];
  String clees;
  String _value;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  DialogBox dialogBox = new DialogBox();
  
  InterstitialAd myInterstitial;

  InterstitialAd buildInterstitialAd(){
    return InterstitialAd(
      adUnitId: AD_MOB_AD_ID,
      listener: (MobileAdEvent event){
        if(event == MobileAdEvent.failedToLoad){
          myInterstitial..load();
        } else if(event == MobileAdEvent.closed){
          myInterstitial = buildInterstitialAd()..load();
        }
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
  super.initState();

  FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);

  myInterstitial = buildInterstitialAd()..load();

        _firebaseMessaging.getToken().then((token) => print(token));

        _firebaseMessaging.configure(
    	onMessage: (Map<String, dynamic> message) async {
        dialogBox.information(context, message['notification']['body'], message['notification']['title']);
    	},

    	onLaunch: (Map<String, dynamic> message) {
    	},

    	onResume: (Map<String, dynamic> message) {
    	}
    );
        restore();
        _firebase();
        FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);
      }
  
  void _logoutUser() async{
    try{
      await widget.auth.singOut();
      widget.onSignedOut();
    } catch(e){
    }
  }

    restore() async{
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      clees = (sharedPrefs.getString('key') ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {

  var size = MediaQuery.of(context).size;
  final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
  final double itemWidth = size.width / 2;


    return new Scaffold(
      body: new Container(
        child: postsList.length == 0 ? new Center(
          child: new Column(
            children: <Widget>[
              _getList(),
              new SizedBox(height: 20.0,),
              Text("En cours de chargement ...")
            ]
          )
        ) 
        : new Container(
          child:
          new Column(
            children: <Widget>[
              
              new SizedBox(height: 12.0,),
              _getList(),
              new SizedBox(height: 3.0,),
              new Expanded(
                child: 
                  new GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: (itemWidth / itemHeight),
                      controller: new ScrollController(keepScrollOffset: false),
                      shrinkWrap: true,
                      children: List.generate(postsList.length, (index){
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
                    }
                    ),
                  ),
              ),
            ],
          )
        )
      ),

      bottomNavigationBar: new BottomAppBar(
        color: Colors.white70,
        child: new Container(
          margin: const EdgeInsets.only(left: 50.0, right: 50.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              new IconButton(
                icon: new Icon(Icons.close),
                iconSize: 40,
                color: Colors.black,
                onPressed: (){_logoutUser();}
              ),
              new IconButton(
                icon: new Icon(Icons.account_box),
                iconSize: 40,
                color: Colors.black,
                onPressed: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new UserPage(clees);
                  })
                );}
              ),
              new IconButton(
                icon: new Icon(Icons.message),
                iconSize: 40,
                color: Colors.black,
                onPressed: (){Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new ChatBody(
                      keys: clees,
                    );
                  })
                );}
              ),
              new IconButton(
                icon: new Icon(Icons.add_a_photo), 
                iconSize: 40, 
                color: Colors.black, 
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return new UploadPhotoPage();
                    })
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _getList(){
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
              if (index == 1 || index == 3 || index == 5 || index == 7){
                myInterstitial = buildInterstitialAd()..load();
                myInterstitial..show();
                print("index : " + index.toString());
              }
              _firebase();
            },
          );
        },
      )
    );
  }

  _firebase(){
    categories.clear();
    
    postsList.clear();
    FirebaseDatabase database = new FirebaseDatabase();
    DatabaseReference postsRef = FirebaseDatabase.instance.reference();
    Query query;
    if(_value == "Tous" || _value == null){
      query = postsRef.child("Posts_2");
    } else{
      query = postsRef.child("Posts_2").orderByChild("categorie").equalTo(_value);
    }

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

      postsList.add(posts);
    }

    setState(() {
    });
      
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    cat.keepSynced(true);
    query.keepSynced(true);
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
    String _etat;
    if (vendue){
      _etat = "Non Disponible";
    } else{
      _etat = "Disponible";
    };

    return new Card(
          elevation: 5.0,
           margin: EdgeInsets.all(7.0),
          child: new Container(
            padding: new EdgeInsets.all(1.0),

            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      icons(vendue),
                      new Text(
                        _etat,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15.0
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],),
                  ],
                ),

                SizedBox(height:2.0),

                Expanded(
                  child: new GestureDetector(
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
                ),

                SizedBox(height: 5.0,),

                new Text(
                  description,
                  style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0
                          ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 5.0,),
                
                new Text(
                      prix,
                      textScaleFactor: 1.5,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                ),

                new FlatButton(
                      child: Row(children: <Widget>[
                        new Icon(
                          Icons.call,
                          size: 25.0,
                          color: Colors.green,
                        ),

                        new SizedBox(width: 5.0),
                        new Text(
                          contact,
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                          ),
                          textAlign: TextAlign.left,
                        ),
                    ],),
                      onPressed: () => launch("tel:"+contact),
                    ),
                  FlatButton(
                    child: Row(children: <Widget>[
                        new Icon(
                          Icons.message,
                          size: 25.0,
                          color: Colors.green,
                        ),

                        new SizedBox(width: 5.0),
                        new Text(
                          "Ecrire un message",
                          style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 15.0
                          ),
                          textAlign: TextAlign.left,
                        ),
                    ],),
                    onPressed: (){
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context){
                        return new Chat(
                          keyDe: clees,
                          keyA: key,
                          keyDisc: null
                        );
                      })
                    );
                    },
                    ),
              ],
            ),
          ),  
        );
  }
}