import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentification.dart';
import 'DialogBox.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~9280199540';
const String AD_MOB_AD_ID = 'ca-app-pub-2474010233453501/8171808024';

class LoginRegisterPage extends StatefulWidget{
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  State<StatefulWidget> createState(){
    return _LoginRegisterState();
  }
}

enum FormType{
  login,
  register
}

class _LoginRegisterState extends State<LoginRegisterPage>{

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

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = "";
  String _pseudo = "";
  String _password = "";
  String _telephone ="";
  String key;

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    } else{
      return false;
    }
  }

  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        _onLoading();
      } catch (e){
        dialogBox.information(context, "Erreur : ", e.toString());
          print("Error = " + e.toString());
      }
    }
  }

  void moveToRegister(){
    formKey.currentState.reset();

    setState((){
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();

    setState((){
      _formType = FormType.login;
    });
  }

  void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            new CircularProgressIndicator(),
            SizedBox(width: 10.0,),
            new Text("Veuillez patienter"),
          ],
        ),
      );
    },
  );
    new Future.delayed(new Duration(seconds: 3), () async {
    if(_formType == FormType.register){
          String userId = await widget.auth.SignUp(_email, _password, _telephone);
          Navigator.pop(context);
          myInterstitial = buildInterstitialAd()..load();
          myInterstitial..show();
        } else{
          String userId = await widget.auth.SignIn(_email, _password);
          Navigator.pop(context);
          myInterstitial = buildInterstitialAd()..load();
          myInterstitial..show();
        }

        widget.onSignedIn();
  });
}


  @override
  void initState(){
    super.initState();
     myInterstitial = buildInterstitialAd()..load();
    restore();
  }

  restore() async{
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      key = (sharedPrefs.getString('key') ?? false);
    });
  }
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new SingleChildScrollView(
        child: new Container(
        child: new Container(
          margin: EdgeInsets.all(15.0),
          child: new Form(
            key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                _formType == FormType.login ?
                createLogin() + createInputs() :
                createLogins() + createInputs(),
              )
          ),
        ),
      )
      )
    );
  }

  List <Widget> createInputs(){
    if (_formType == FormType.login){
      return [
        Padding(
          padding: EdgeInsets.only(left:0, right:0, top: width / 13),
          child: Container(
              height: width / 12,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[100]),
                  top: BorderSide(color: Colors.grey[100]),
                  left: BorderSide(color: Colors.grey[100]),
                  right: BorderSide(color: Colors.grey[100])
              ),
              color: Colors.white
            ),
              child: Center(
                child: FlatButton(
                  child: new Text("Connexion", style: new TextStyle(color: Colors.black,
                      fontSize: width / 20)),
                  onPressed: validateAndSubmit,
                ),
              ),
            ),
        ),

        SizedBox(height: MediaQuery.of(context).size.width / 10),

        Container(
          height: width / 12,
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[100]),
                  top: BorderSide(color: Colors.grey[100]),
                  left: BorderSide(color: Colors.grey[100]),
                  right: BorderSide(color: Colors.grey[100])
              ),
              color: Colors.black
          ),
          child: Center(
            child: new FlatButton(
              child: new Text(
                  "Pas de compte? Créer un compte", style: new TextStyle(fontSize: width / 23)),
              textColor: Colors.white,
              onPressed: moveToRegister,
            ),
          ),
        ),

        new FlatButton(
          child: new Text(
              "Mot de passe oublié ?", style: new TextStyle(fontSize: width / 23)),
          textColor: Colors.white,
          onPressed: moveToRegister,
        ),
      ];
    } else{
      return [
        Padding(
          padding: EdgeInsets.only(left:width/10, right:width/10, top: width / 13),
          child: Container(
            height: width / 12,
            decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[100]),
                  top: BorderSide(color: Colors.grey[100]),
                  left: BorderSide(color: Colors.grey[100]),
                  right: BorderSide(color: Colors.grey[100])
              ),
              color: Colors.white,
            ),
            child: Center(
              child: FlatButton(
                child: new Text("Inscription", style: new TextStyle(color: Colors.black,
                    fontSize: width / 20)),
                onPressed: validateAndSubmit,
              ),
            ),
          ),
        ),

        new FlatButton(
          child: new Text(
              "Vous êtes inscris, connectez-vous", style: new TextStyle(fontSize: width / 24)),
          textColor: Colors.white,
          onPressed: moveToLogin,
        ),

      ];
    }
  }

  Widget logo(){
    return Column(
      children: <Widget>[
        Container(
        height: width / 3,
            width: width / 3,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/image/logo.png')
                )
            )
        ),
        Text('Deal Tout',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width / 14,
          ),
        ),
      ],
    );
  }

  List<Widget> createLogins(){
    return[
      SizedBox(height: width / 7),
      logo(),
      SizedBox(height: width / 10),
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[100]),
                        top: BorderSide(color: Colors.grey[100]),
                        left: BorderSide(color: Colors.grey[100]),
                        right: BorderSide(color: Colors.grey[100])
                    ),
                ),

                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "  Pseudo",
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                  validator: (value){
                    return value.isEmpty ? 'Pseudo requis.' : null;
                  },

                  onSaved: (value){
                    return _pseudo = value;
                  },
                )
            ),

            SizedBox(height: 5.0),

            Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[100]),
                      top: BorderSide(color: Colors.grey[100]),
                      left: BorderSide(color: Colors.grey[100]),
                      right: BorderSide(color: Colors.grey[100])
                  ),
                ),

                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "  Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                  validator: (value){
                    return value.isEmpty ? 'Email requis.' : null;
                  },

                  onSaved: (value){
                    return _email = value;
                  },
                )
            ),

            SizedBox(height: 5.0),

            Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[100]),
                      top: BorderSide(color: Colors.grey[100]),
                      left: BorderSide(color: Colors.grey[100]),
                      right: BorderSide(color: Colors.grey[100])
                  ),
                ),

                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "  N° Phone",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                  validator: (value){
                    return value.isEmpty ? 'N° Téléphone requis.' : null;
                  },

                  onSaved: (value){
                    return _telephone = value;
                  },
                )
            ),

            SizedBox(height: 5.0),

            Container(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[100]),
                      top: BorderSide(color: Colors.grey[100]),
                      left: BorderSide(color: Colors.grey[100]),
                      right: BorderSide(color: Colors.grey[100])
                      ),
                  color: Colors.transparent
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "   Mot de passe",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400]
                      )
                  ),
                  validator: (value){
                    return value.isEmpty ? 'Password requis.' : null;
                  },

                  onSaved: (value){
                    return _password = value;
                  },
                )
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> createLogin(){
    return[
      SizedBox(height: width / 7),
      logo(),
      SizedBox(height: width / 10),
      Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey[100]),
                      top: BorderSide(color: Colors.grey[100]),
                      left: BorderSide(color: Colors.grey[100]),
                      right: BorderSide(color: Colors.grey[100])
                  ),
                ),

                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "  Email",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400])
                  ),
                  validator: (value){
                    return value.isEmpty ? 'Email requis.' : null;
                  },

                  onSaved: (value){
                    return _email = value;
                  },
                )
            ),

            SizedBox(height: 5.0),

            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[100]),
                        top: BorderSide(color: Colors.grey[100]),
                        left: BorderSide(color: Colors.grey[100]),
                        right: BorderSide(color: Colors.grey[100])
                    ),
                    color: Colors.transparent
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "   Mot de passe",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey[400]
                      )
                  ),
                  validator: (value){
                    return value.isEmpty ? 'Password requis.' : null;
                  },

                  onSaved: (value){
                    return _password = value;
                  },
                )
            ),
          ],
        ),
      ),
    ];
  }
}