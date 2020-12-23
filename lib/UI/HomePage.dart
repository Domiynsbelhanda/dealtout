import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UI/Affichage.dart';
import '../UI/Categories.dart';
import '../UI/DialogBox.dart';
import '../UI/PhotoUploadPage.dart';
import 'package:flutter/material.dart';
import '../Util/Authentification.dart';
import '../Util/Posts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../UI/UserPage.dart';
import 'ChatBody.dart';
import 'ListChat.dart';

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

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final AuthImplementation auth = new Auth();
  
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
        showInSnackBar(message['notification']['body'], _scaffoldKey, context);
    	},

    	onLaunch: (Map<String, dynamic> message) {
    	},

    	onResume: (Map<String, dynamic> message) {
    	}
    );
      }
  
  void _logoutUser(context){
      auth.signOut(context);
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      key: _scaffoldKey,
      body: Body(),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) => setState((){
          _currentIndex = newIndex;

          if(_currentIndex == 0){
            // User Profile
          } else if (_currentIndex == 1){
            Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new UploadPhotoPage();
                  })
              );
          }
        }),

        items: [
          new BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.userTie,
              color: Colors.black,
            ),
            title: new Text("USER")
          ),

          new BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.plusSquare,
              color: Colors.black,
            ),
            title: new Text("ADD")
          ),

          new BottomNavigationBarItem(
            icon: new Icon(
              FontAwesomeIcons.upload,
              color: Colors.black,
            ),
            title: new Text("Publier un article")
          ),


        ]
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        Categories(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPaddin,
                  crossAxisSpacing: kDefaultPaddin,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => ItemCard(
                      product: products[index],
                      press: (){
                        
                      }// => Navigator.push(
                          //context,
                          //MaterialPageRoute(
                            //builder: (context) => DetailsScreen(
                              //product: products[index],
                           // ),
                         // )),
                    )),
          ),
        ),
      ],
    );
  }
}

class ItemCard extends StatelessWidget {
  final Product product;
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
              padding: EdgeInsets.all(kDefaultPaddin),
              // For  demo we use fixed height  and width
              // Now we dont need them
              // height: 180,
              // width: 160,
              decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(
                tag: "${product.id}",
                child: Image.asset(product.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              // products is out demo list
              product.title,
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          Text(
            "\$${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}


class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["Hand bag", "Jewellery", "Footwear", "Dresses"];
  // By default our first item will be selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? kTextColor : kTextLightColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
