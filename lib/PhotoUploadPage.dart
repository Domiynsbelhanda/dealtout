import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'HomePage.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~9280199540';
const String AD_MOB_AD_ID = 'ca-app-pub-2474010233453501/8171808024';

class UploadPhotoPage extends StatefulWidget{

  @override
  State <StatefulWidget> createState() {
    return _UploadPhotoPageState();
  }
}

class _UploadPhotoPageState extends State<UploadPhotoPage>{

  File sampleImage;
  String _myValue;
  String _prix;
  String _contact;
  String url;
  String key;
  String _value;
  final formKey = new GlobalKey<FormState>();

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

  Future getImage() async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    } else{
      return false;
    }
  }

  void uploadStatusImage() async{
    if(validateAndSave()){
      _onLoading();
    }
  }

void _onLoading() {
  showDialog(
    context: context,
    barrierDismissible: false,
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
    final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Post Images");

      var timeKey = new DateTime.now();

      final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImageUrl.toString();
      saveToDatabase(url);
      Navigator.pop(context);
      myInterstitial = buildInterstitialAd()..load();
      myInterstitial..show();
      goToHomePage();
  });
}

  void saveToDatabase(url){
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('d MMM, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data={
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
      "key": key,
      "prix": _prix,
      "contact": _contact,
      "categorie": _value,
      "vendue": false,
      "images": DateTime.now().toString()
    };

    ref.child("Posts_2").push().set(data);
  }

  void goToHomePage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder:(context){
        return new HomePage();
      })
    );
  }

  @override
  void initState(){
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);

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
      appBar: new AppBar(
        title: new Text("Publication Image"),
        centerTitle: true,
      ),

      body: new Center
      (
        child: sampleImage == null ? Text("Selectionner une image"): enableUpload(),
      ),

      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Ajouter une image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload(){
    return new Container(
      child: new Form(
      key: formKey,

      child: new SingleChildScrollView(
        child:Column(
        children: <Widget>[
          Image.file(sampleImage, height: 250.0, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,),

          SizedBox(height: 15.0,),

          TextFormField(
            decoration: new InputDecoration(labelText: 'Description'),

            validator: (value){
              return value.isEmpty ? 'La description est requise' : null;
            },

            onSaved: (value){
              return _myValue = value;
            },
          ),

          SizedBox(height: 15.0,),

          TextFormField(
            decoration: new InputDecoration(labelText: 'Prix (Ex: 1000FC ou 10\$'),

            validator: (value){
              return value.isEmpty ? 'Le prix est requise' : null;
            },

            onSaved: (value){
              return _prix = value;
            },
          ),

          SizedBox(height: 15.0,),

          TextFormField(
            decoration: new InputDecoration(labelText: 'N° Téléphone'),

            validator: (value){
              return value.isEmpty ? 'N° Téléphone requise' : null;
            },

            onSaved: (value){
              return _contact = value;
            },
          ),

          SizedBox(height: 15.0),

          DropdownButton<String>(
            items: [
                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.all_inclusive),
                        SizedBox(width:5.0),
                        Text("Toutes les categories", 
                        style: new TextStyle(fontSize: 20.0, color: Colors.black))]),
                        value: "Tous"),

                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.phone_android),
                        SizedBox(width:5.0),
                        Text("Téléphone")]),
                        value: "Téléphone"),

                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.style),
                        SizedBox(width:5.0),
                        Text("Habillement")]),
                        value: "Habillement"),

                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.airport_shuttle),
                        SizedBox(width:5.0),
                        Text("Voiture")]),
                        value: "Voiture"),
                    
                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.airline_seat_flat),
                        SizedBox(width:5.0),
                        Text("Animal")]),
                        value: "Animal"),

                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.home),
                        SizedBox(width:5.0),
                        Text("Maison")]),
                        value: "Maison"),

                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.info_outline),
                        SizedBox(width:5.0),
                        Text("Autres produits")]),
                        value: "Autres"),
                  ],
            onChanged: (String value){
            setState(() {
              _value = value;
            });
            },
            hint: DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.all_inclusive),
                        SizedBox(width:5.0),
                        Text("Toutes les categories", 
                        style: new TextStyle(fontSize: 20.0, color: Colors.black))]),
                        value: "Tous"),
            value: _value,
          ),

          SizedBox(height: 15.0),

          RaisedButton(
            elevation: 10.0,
            child: Text("Poster l'Article"),
            textColor: Colors.white,
            color: Colors.black,

            onPressed: uploadStatusImage,
          )
        ],
      )
      )
    
    )
    );
  }
}