import 'package:DEALTOUT/UI/Profile.dart';
import 'package:DEALTOUT/Util/Authentification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'Your_Publication.dart';
import 'components/profile_menu.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~9280199540';

class UserPage extends StatefulWidget{

  @override
  State <StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage>{

  final AuthImplementation auth = new Auth();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
   
  }

    void _logoutUser(context){
      auth.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
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

      body: new SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfileMenu(
              text: "Mon Compte",
              icon: FontAwesomeIcons.userTie,
              press:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return new Profile();
                  })
              );
              }
            ),

            ProfileMenu(
              text: "Vos publications",
              icon: FontAwesomeIcons.archive,
              press:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return YourPublication();
                  })
                );
              }
            ),

            ProfileMenu(
              text: "Déconnexion",
              icon: FontAwesomeIcons.userSlash,
              press:(){
                _logoutUser(context);
              }
            )
          ],
        )
      ),
    );
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
}