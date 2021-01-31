import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Styles/Constants.dart';
import 'Util/Authentification.dart';
import 'Util/Mapping.dart';
import 'package:splashscreen/splashscreen.dart';
    
    Future<void> main() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      runApp(new DealApp(),);
    }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<Widget> loadFromFuture() async {

    return Future.value(MappingPage(auth: Auth() ));
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      navigateAfterFuture: loadFromFuture(),
      seconds: 15,
      title: new Text('Deal Tout',
      style: GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: MediaQuery.of(context).size.width / 14,
      ),),
      image: new Image.asset('assets/images/image/logo.png'),
      photoSize: 100,
      backgroundColor: Colors.black,
    );
  }
}

    class DealApp extends StatelessWidget{

        @override
        Widget build(BuildContext context) {
            return new MaterialApp(
                title: "DealTout",
                debugShowCheckedModeBanner: false,
                theme: new ThemeData(
                    primarySwatch: Colors.blue,
                    textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
                ),
                home: MyApp(), //MappingPage(auth: Auth(), )
            );
        }
    }