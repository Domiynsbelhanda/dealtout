import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AffichageImage extends StatefulWidget{

  String image;
  AffichageImage(this.image);

  @override
  State <StatefulWidget> createState() {
    return _Affichage(this.image);
  }
}

class _Affichage extends State<AffichageImage>{
  String image;
  _Affichage(this.image);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.black12,
      appBar: new AppBar(
        title: new Text("Article"),
      ),
      body: new Center(
        child:
                new Image.network(
                    image,
                    height: 400.0,
                    width: MediaQuery.of(context).size.width,
                    fit:BoxFit.fitWidth
                ),
      ),
    );
  }
}