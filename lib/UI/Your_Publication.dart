import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/Util/Authentification.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'HomePage.dart';
import 'details_screen.dart';
import 'details_screens.dart';

class YourPublication extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Your_Publication();
  }
}

class _Your_Publication extends State<YourPublication>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Products> produits = [];
  Users users;

  @override
  void initState(){
    super.initState();
    user_data();
    liste_art();
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                FontAwesomeIcons.chevronCircleLeft,
                color: Colors.black
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
        ),
      body: Body(context),
    );
  }

  Widget Body (context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                      press: ()=> Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreens(
                              product: produits[index],
                              users: users
                            ),
                         )),
                    )),
          ),
        ),
      ],
    );
  }


  void liste_art() async {

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    final uids = user.uid;

      produits = [];

    FirebaseFirestore.instance
    .collection('Article')
    .where('key', isEqualTo: uids)
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
}