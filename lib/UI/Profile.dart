import 'package:DEALTOUT/Util/Authentification.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Profile();
  }
}

class _Profile extends State<Profile>{

  final AuthImplementation auth = new Auth();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Users users;

  @override
  void initState(){
    super.initState();

    user_data();
    
  }

  @override
  void dispose(){
    myFocusNodeName.dispose();
    myFocusNodePhone.dispose();
  }

  void user_data() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uids = user.uid;

    Firestore.instance
    .collection('Users')
    .where('key', isEqualTo: uids)
    .snapshots()
    .listen((data) =>
        data.documents.forEach((doc) { setState(() {
          users = Users(
            key: doc['key'],
            email: doc['email'],
            telephone: doc['telephone'],
            name: doc['name']
          );
        });
        }));
  }

  final FocusNode myFocusNodePhone = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
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

        body: new SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[

              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  users.name,
                  style: GoogleFonts.lato(
                    fontSize: 20.0,
                  )
                ),
              ),

              Padding(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  users.telephone,
                  style: GoogleFonts.lato(
                    fontSize: 15.0,
                  )
                ),
              ),

              Padding(
                padding: EdgeInsets.all(0.0),
                child: Text(
                  users.email,
                  style: GoogleFonts.lato(
                    fontSize: 10.0,
                  )
                ),
              ),


              SizedBox(height: 15.0),

              Text(
                "MODIFIEZ VOS INFORMATIONS",
                style: TextStyle(
                  fontSize: 15.0,
                  decoration: TextDecoration.underline
                ),
              ),

              SizedBox(height: 10.0),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: name,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.fileSignature,
                              size: 22.0,
                              color: Colors.black
                            ),
                            hintText: "Entrez votre nouveau nom",
                            hintStyle: TextStyle(
                            )
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhone,
                          controller: phone,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black
                          ),
                          decoration: InputDecoration(
                            icon: Icon(
                              FontAwesomeIcons.phone,
                              size: 22.0,
                              color: Colors.black
                            ),
                            hintText: "Nouveau numéro de téléphone",
                            hintStyle: TextStyle(
                            )
                          ),
                        ),
                      ),
                    
                    ],
                  )
                )
              )
              ),


              FlatButton(
                onPressed: () async{
                  if(name.text.isEmpty && phone.text.isEmpty){
                    showInSnackBar("Aucune modification detéctée.");
                  } else if (name.text.isEmpty && phone.text.isNotEmpty){
                    var data={
                      "telephone": phone.text
                    };
                    final Firestore _firestore = Firestore.instance;
                    await
                    _firestore.collection('Users').document(users.key).updateData(data);

                    showInSnackBar("Modification du numéro de téléphone");
                  } else if (name.text.isNotEmpty && phone.text.isEmpty){
                    var data={
                      "name": name.text
                    };
                    final Firestore _firestore = Firestore.instance;
                    await
                    _firestore.collection('Users').document(users.key).updateData(data);
                      showInSnackBar("Modification de votre pseudo");
                  } else if (name.text.isNotEmpty && phone.text.isNotEmpty){
                    var data={
                      "telephone": phone.text,
                      "name": name.text
                    };
                    final Firestore _firestore = Firestore.instance;
                    await
                    _firestore.collection('Users').document(users.key).updateData(data);
                    showInSnackBar("Modification du pseudo et du numéro");
                  }
                },
                child: Text(
                  "UPDATE",
                  style: GoogleFonts.lato(
                    fontSize: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
                ),
                color: Color(0xFFFF7643),
              )

            ],
          ),
        )
    );
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