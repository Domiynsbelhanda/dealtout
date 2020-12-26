import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget{

  @override
  State <StatefulWidget> createState() {
    return _About();
  }
}

class _About extends State<About>{

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronCircleLeft,
            color: Colors.black
          ),
          onPressed: ()=> Navigator.pop(context),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
      backgroundColor: Colors.white,
      body: Column(
            children: <Widget>[
              SizedBox(height: 20.0),

              Center(
                child: Icon(
                  FontAwesomeIcons.exclamationTriangle,
                  size: 100.0,
                  color: Colors.black,
                )
              ),

              SizedBox(height: 20.0),

              Text(
                "Conseil de sécurité : ",
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 10.0),

              Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  """1 - Ne pas envoyer d'argent par des moyens de transfert d'argent, par virement bancaire ou par n'importe quels autres moyens.
                  \n2 - Donnez rendez-vous au vendeur dans un lieu public à une heure de passage.
                  """,

                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 13.0,
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              Text(
                "Plus d'infos :",

                style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),

              FlatButton(
                onPressed: ()=>launch("tel:+243978972707"),
                child: Text(
                  "Tony MUKENDI : +243978972707",

                  style: GoogleFonts.lato(
                    color: Colors.black,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ],
          )
    );
  }
}