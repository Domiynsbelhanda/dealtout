import 'package:DEALTOUT/UI/DialogBox.dart';
import 'package:DEALTOUT/UI/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

save(String key, dynamic value) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.setString(key, value);
}

abstract class AuthImplementation{
  Future<String> SignIn(String email, String password, context, _scaffoldKey);
  Future<String> SignUp(String email, String password, String telephone, String name, context, _scaffoldKey);
  Future<String> getCurrentUser();
  Future<void> resetmail(String email, context, _scaffoldKey);
  Future<void> signOut(context);
}


class Auth implements AuthImplementation{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  VoidCallback onSignedIn;
  VoidCallback onSignedOut;

  Future<String> SignIn(String email, String password, context, _scaffoldKey) async{
    try{
      FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      showInSnackBar("Connectée.", _scaffoldKey, context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
         ));
      onSignedIn();
      return user.uid;
    } on PlatformException catch (exception) {
      if(exception.code =="ERROR_WRONG_PASSWORD"){
        showInSnackBar("Mot de passe incorrect.", _scaffoldKey, context);
      }
      else if(exception.code =="ERROR_USER_NOT_FOUND"){
        showInSnackBar("Vous n'avez pas de compte.", _scaffoldKey, context);
      }
      else if (exception.code =="ERROR_USER_DISABLED"){
        showInSnackBar("Compte desactivé par l'admin", _scaffoldKey, context);
      } else if (exception.code =="ERROR_INVALID_EMAIL"){
        showInSnackBar("Adresse mail invalide.", _scaffoldKey, context);
      } else if (exception.code =="ERROR_TOO_MANY_REQUESTS"){
        showInSnackBar("Erreur, too many requests", _scaffoldKey, context);
      }
      else {
        showInSnackBar(exception.code, _scaffoldKey, context);
      }
    } 
  }

  Future<String> SignUp(String email, String password, String telephone, String name, context, _scaffoldKey) async{
    try{

      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

      var data={
        "key": user.uid.toString(),
        "email": email,
        "password": password,
        "telephone": telephone,
        "name": name,};

        final Firestore _firestore = Firestore.instance;
        await
        _firestore.collection('Users').document(user.uid.toString()).setData(data);
        showInSnackBar("Inscription effectuée.", _scaffoldKey, context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
         ));
        onSignedIn();

         return user.uid;
        
      } on PlatformException catch (exception) {
        if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
          showInSnackBar("Adresse mail déjà utilisée.", _scaffoldKey, context);
        } else {
          showInSnackBar(exception.message, _scaffoldKey, context);
        }
    }

  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut(context) async{
    _firebaseAuth.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(),
         ));
             onSignedOut();
  }

  Future<void> resetmail(String email, context, _scaffoldKey) async{

    try{

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showInSnackBar("Email de restauration envoyé.", _scaffoldKey, context);

     
      } on PlatformException catch (exception) {
        if (exception.code == "ERROR_INVALID_EMAIL") {
          showInSnackBar("Erreur, votre adresse mail est invalide.", _scaffoldKey, context);
        } else {
          showInSnackBar(exception.message, _scaffoldKey, context);
        }
    }
 }

 void showInSnackBar(String value, _scaffoldKey, context) {
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