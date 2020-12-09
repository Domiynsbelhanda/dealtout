import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

save(String key, dynamic value) async {
  final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.setString(key, value);
}

abstract class AuthImplementation{
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password, String telephone);
  Future<String> getCurrentUser();
  Future<void> singOut();
}

class Auth implements AuthImplementation{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> SignIn(String email, String password) async{
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    save('key', user.uid.toString());
    return user.uid;
  }

  Future<String> SignUp(String email, String password, String telephone) async{
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data={
      "key": user.uid.toString(),
      "email": email,
      "password": password,
      "telephone": telephone
    };

    ref.child("Users").child(user.uid.toString()).set(data);

    save('key', user.uid.toString());
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> singOut() async{
    save('key', null);
    _firebaseAuth.signOut();
  }

}