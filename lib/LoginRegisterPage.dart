import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
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
  String _password = "";
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
          String userId = await widget.auth.SignUp(_email, _password);
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black12,
      appBar: new AppBar(
        title: new Text("DEAL TOUT"),
      ),
      body: new SingleChildScrollView(
        child: new Container(
        child: new Container(
          margin: EdgeInsets.all(15.0),
          child: new Form(
            key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createLogin() + createInputs(),
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
        new RaisedButton(
          child: new Text("Connexion", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.black87,
          color: Colors.white,
          onPressed: validateAndSubmit,
        ),

        new RaisedButton(
          child: new Text(
              "Pas de compte? Créer un compte", style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.black,
          onPressed: moveToRegister,
        ),
      ];
    } else{
      return [
        new RaisedButton(
          child: new Text("Inscription", style: new TextStyle(fontSize: 20.0)),
          textColor: Colors.black87,
          color: Colors.white,
          onPressed: validateAndSubmit,
        ),

        new RaisedButton(
          child: new Text(
              "Vous êtes inscris, connectez-vous", style: new TextStyle(fontSize: 14.0)),
          textColor: Colors.black,
          onPressed: moveToLogin,
        ),

      ];
    }
  }

  Widget logo(){
    return new Hero(
      tag: 'Hero',
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
          radius: 110.0,
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/dealtout-cb535.appspot.com/o/dealTout_logo.png?alt=media&token=864499f0-6c6f-41cb-a76d-278cacc94b4f'
          ),
      )
    );
  }

  List<Widget> createLogin(){
    return[
      SizedBox(height: 10.0),
      logo(),
      SizedBox(height: 10.0),

      new TextFormField(
         decoration: new InputDecoration(
                    fillColor: Colors.white,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 30.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      labelText: 'Email'),

        validator: (value){
          return value.isEmpty ? 'Email requis.' : null;
        },

        onSaved: (value){
          return _email = value;
        },
      ),
      SizedBox(height: 10.0),

      new TextFormField(
        decoration: new InputDecoration(
                    fillColor: Colors.white,
                      filled: true,
                      contentPadding: new EdgeInsets.fromLTRB(
                          10.0, 30.0, 10.0, 10.0),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(12.0),
                      ),
                      labelText: 'Password'),

        validator: (value){
          return value.isEmpty ? 'Password requis.' : null;
        },

        onSaved: (value){
          return _password = value;
        },
      ),

      SizedBox(height: 20.0),
    ];
  }
}