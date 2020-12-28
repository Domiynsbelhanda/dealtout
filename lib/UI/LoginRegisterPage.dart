import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/Authentification.dart';
import 'DialogBox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~9280199540';
const String AD_MOB_AD_ID = 'ca-app-pub-2474010233453501/8171808024';

class LoginRegisterPage extends StatefulWidget{
  LoginRegisterPage({
    this.auth,
    this.onSignedIn,
    Key key
  }) : super(key: key);

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

class _LoginRegisterState extends State<LoginRegisterPage>
  with SingleTickerProviderStateMixin {

  final AuthImplementation auth = new Auth();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();

  TextEditingController loginemailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPhoneController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    } else{
      return false;
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


  @override
  void initState(){
    super.initState();
     myInterstitial = buildInterstitialAd()..load();
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return new Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: new SingleChildScrollView(
        child: new Container(
        child: new Container(
          margin: EdgeInsets.all(15.0),
          child: new Form(
            key: formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  logo(),
                  _formType == FormType.login ?
                _buildSignIn(context) :
                _buildSignUp(context),
                ]
              )
          ),
        ),
      )
      )
    );
  }

    @override
    void dispose() {
      myFocusNodePassword.dispose();
      myFocusNodeEmail.dispose();
      myFocusNodeName.dispose();
      myFocusNodePhone.dispose();
      super.dispose();
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

  Widget _buildSignIn(BuildContext context){
      return Container(
        padding: EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    height: 190.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0
                          ),
                          child: TextField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginemailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email",
                            ),
                          ),
                        ),

                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Mot de passe",
                              hintStyle: TextStyle(
                                fontSize: 17.0
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ),
                
                Container(
                  margin: EdgeInsets.only(top: 200.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: MaterialButton(
                      highlightColor: Colors.white,
                      splashColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0
                        ),
                        child: Text(
                          "Connexion",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if(
                            loginemailController.text.isEmpty 
                            || loginPasswordController.text.isEmpty){
                          showInSnackBar("Completez toute les cases correctement.");
                        } else if (loginPasswordController.text.length < 6){
                          showInSnackBar("Mot de passe trop court");
                        } 
                        else {
                          auth.SignIn(
                          loginemailController.text,
                          loginPasswordController.text,
                          context, _scaffoldKey);
                          myInterstitial = buildInterstitialAd()..load();
                          myInterstitial..show();
                        }
                      }
                    )
                  )
              ],
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                onPressed: moveToRegister,
                child: Text(
                  "Pas de compte, Creez-en un ici.",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 16.0,
                  )
                )
              )
            ),

            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: FlatButton(
                onPressed: (){
                  if (loginemailController.text.isEmpty){
                    showInSnackBar("Entrez l'adresse mail, sur la place de l'email.");
                  } else {
                    auth.resetmail(loginemailController.text, context, _scaffoldKey);
                  }
                },
                child: Text(
                  "Mot de passe oublié",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.white,
                    fontSize: 16.0,
                  )
                )
              )
            )
          ],
        ),
      );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 450.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeName,
                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Nom",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmail,
                          controller: signupEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Adresse Mail",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePhone,
                          controller: signupPhoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.black,
                            ),
                            hintText: "N° Téléphone",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePassword,
                          controller: signupPasswordController,
                          obscureText: _obscureTextSignup,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Mot de passe",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignup,
                              child: Icon(
                                _obscureTextSignup
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          controller: signupConfirmPasswordController,
                          obscureText: _obscureTextSignupConfirm,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Confirmation mot de passe",
                            hintStyle: TextStyle(
                                fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignupConfirm,
                              child: Icon(
                                _obscureTextSignupConfirm
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 470.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: MaterialButton(
                    highlightColor: Colors.white,
                    splashColor: Colors.white,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Inscription",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,),
                      ),
                    ),
                    onPressed: (){
                      if(signupNameController.text.isEmpty || 
                        signupPasswordController.text.isEmpty ||
                        signupConfirmPasswordController.text.isEmpty || 
                        signupPhoneController.text.isEmpty ||
                        signupEmailController.text.isEmpty)
                        {
                          showInSnackBar("Completez toute les cases");
                        }
                        else if (signupPasswordController.text.length < 6){
                          showInSnackBar("Mot de passe trop court");}
                        else if (signupConfirmPasswordController.text != signupPasswordController.text)
                        {
                          showInSnackBar("Mot de passe de confirmation différent");
                        }
                        else {
                          auth.SignUp(
                            signupEmailController.text,
                            signupPasswordController.text,
                            signupPhoneController.text,
                            signupNameController.text,
                            context,
                            _scaffoldKey
                          );
                          myInterstitial = buildInterstitialAd()..load();
                          myInterstitial..show();
                          }
                    }
                ),
              ),
            ],
          ),

        new FlatButton(
          child: new Text(
              "Vous êtes inscris, connectez-vous", style: new TextStyle(fontSize: width / 24)),
          textColor: Colors.white,
          onPressed: moveToLogin,
        ),

        ],
      ),
    );
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

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}