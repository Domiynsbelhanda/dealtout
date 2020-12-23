import 'package:flutter/material.dart';
import '../UI/LoginRegisterPage.dart';
import '../UI/HomePage.dart';
import '../Util/Authentification.dart';

class MappingPage extends StatefulWidget{
  final AuthImplementation auth;

  MappingPage({
    this.auth,
  });

  @override
  State<StatefulWidget> createState() {
    return _MappingPageState();
  }
}

enum AuthStatus{
 notSignedIn,
 signedIn,
}

class _MappingPageState extends State<MappingPage>{

  AuthStatus _authStatus = AuthStatus.notSignedIn;


  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId){
      setState(() {
        _authStatus = firebaseUserId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signOut(){
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(_authStatus){
      case AuthStatus.notSignedIn:
        return new LoginRegisterPage(
          auth: widget.auth,
          onSignedIn: _signedIn
        );

      case AuthStatus.signedIn:
        return new HomePage(
            auth: widget.auth,
            onSignedOut: _signOut
        );
    }

    return null;
  }
}