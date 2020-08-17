import 'package:flutter/material.dart';
import 'Authentification.dart';
import 'Mapping.dart';
    
    void main(){
    runApp(new DealApp());
    }

    class DealApp extends StatelessWidget{

        @override
        Widget build(BuildContext context) {
            return new MaterialApp(
                title: "DealTout",
                debugShowCheckedModeBanner: false,
                theme: new ThemeData(
                    primarySwatch: Colors.blue,
                ),
                home: MappingPage(auth: Auth(), )
            );
        }
    }