import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/UI/UserPage.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as Database;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../UI/DialogBox.dart';
import '../UI/PhotoUploadPage.dart';
import 'package:flutter/material.dart';
import '../Util/Authentification.dart';

import 'About.dart';
import 'Categories.dart';
import 'details_screen.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~8206756914';
const String AD_MOB_AD_ID = 'ca-app-pub-2474010233453501/1425085514';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final AuthImplementation auth = new Auth();

  String _categorisation;
  
  /*InterstitialAd myInterstitial;


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
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
  super.initState();

  /*FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);

  myInterstitial = buildInterstitialAd()..load();*/

    categories.clear();
    Database.FirebaseDatabase database = new Database.FirebaseDatabase();
    Database.DatabaseReference postsRef = Database.FirebaseDatabase.instance.reference();
    Database.Query cat = postsRef.child("Categories");

    cat.once().then((Database.DataSnapshot snap){
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

    liste_art();
    user_data();

  }
  
  void _logoutUser(context){
      auth.signOut(context);
  }

  int _currentIndex = 0;
  List<Categories> categories = []; 
  List<Products> produits = [];
  Users users;
  Users userss;

  void liste_art() async {
    if (_categorisation == null){
      produits = [];

      Query collectionReference = FirebaseFirestore.instance.collection("Article").orderBy('timestamp', descending: false);

    collectionReference
    .snapshots()
    .listen((data) =>
        data.docs.forEach((doc) { setState(() {
          produits.add(Products(
            article: doc['article'],
            categorie: doc['categorie'],
            date: doc['date'],
            description: doc['description'],
            id : doc['id'],
            image: doc['image'],
            key: doc['key'],
            prix: doc['prix'],
            time: doc['time'],
            timestamp: doc['timestamp']
          ));
        });
        }));
    } else {
      produits = [];

      Query collectionReference = FirebaseFirestore.instance.collection("Article").orderBy('timestamp', descending: false);

    collectionReference
    .where('categorie', isEqualTo: _categorisation)
    .snapshots()
    .listen((data) =>
        data.docs.forEach((doc) { setState(() {
          produits.add(Products(
            article: doc['article'],
            categorie: doc['categorie'],
            date: doc['date'],
            description: doc['description'],
            id : doc['id'],
            image: doc['image'],
            key: doc['key'],
            prix: doc['prix'],
            time: doc['time'],
            timestamp: doc['timestamp']
          ));
        });
        }));
    }

  }

  void user_data() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    final uids = user.uid;

    FirebaseFirestore.instance
    .collection('Users')
    .where('key', isEqualTo: uids)
    .snapshots()
    .listen((data) =>
        data.docs.forEach((doc) { setState(() {
          users = Users(
            key: doc['key'],
            email: doc['email'],
            telephone: doc['telephone'],
            name: doc['name']
          );
        });
        }));

  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      body: Body(context),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) => setState((){
          _currentIndex = newIndex;

          if(_currentIndex == 0){
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new UserPage();
                  })
              );
          } else if (_currentIndex == 1){
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new UploadPhotoPage();
                  })
              );
          } else if (_currentIndex == 2){
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new About();
                  })
              );
          }
        }),

        items: [
          new BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.userTie,
              color: Color(0xFFFF7643),
            ),
            title: new Text(
              "USER",
              style: TextStyle(
                color: Color(0xFF000000)
              )
              )
          ),

          new BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.plusSquare,
              color: Color(0xFFFF7643),
            ),
            title: new Text("ADD",
                style: TextStyle(
                  color: Color(0xFF000000)
              ))
          ),

          new BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.infoCircle,
              color: Color(0xFFFF7643),
            ),
            title: new Text(
              "ABOUT",
              style: TextStyle(
                color: Color(0xFF000000)
              )
              )
          ),


        ]
      ),
    );
  }

Widget Body (context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text(
            "Catégorie",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Categorie(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: GridView.builder(
                itemCount: produits.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPaddin,
                  crossAxisSpacing: kDefaultPaddin,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                      product: produits[index],
                      press: (){ 
                        FirebaseFirestore.instance
                          .collection('Users')
                          .where('key', isEqualTo: produits[index].key)
                          .snapshots()
                          .listen((data) =>
                              data.docs.forEach((doc) { setState(() {
                                userss = Users(
                                  key: doc['key'],
                                  email: doc['email'],
                                  telephone: doc['telephone'],
                                  name: doc['name']
                                );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      product: produits[index],
                                      users: userss
                                    ),
                                ));

                              });
                              }));
                         }
                    )),
          ),
        ),
      ],
    );
  }
  

  Widget Categorie(){
    return new Container(
      height:40.0,
      child: new ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index){
          return new GestureDetector(
            child: new Card(
                elevation: 5.0,
                color: Color(0xFFFF7643),
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
                      color: Colors.white,
                      fontSize: 12.0
                    ),
                  ),),

                ],
                ) 
              ),
            ),
            onTap: () {
              setState((){
                if(categories[index].nom == "Toutes"){
                  _categorisation = null;
                } else {
                  _categorisation = categories[index].nom;
                }
                liste_art();
              });
              /*if (index == 1 || index == 3 || index == 5 || index == 7){
                myInterstitial = buildInterstitialAd()..load();
                myInterstirtial..show();
                print("index : " + index.toString());*/
              }
              //_firebase();
          );
        },
      )
    );
  }
}

class ItemCard extends StatelessWidget {
  final Products product;
  final Function press;
  const ItemCard({
    Key key,
    this.product,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(2.0),
              // For  demo we use fixed height  and width
              // Now we dont need them
              height: 180,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Hero(
                tag: "${product.image}",
                child: Image.network(
                  product.image,
                  fit: BoxFit.fitWidth,
                  ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.article,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "${product.prix}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
                  ],
      ),
    );
  }
}