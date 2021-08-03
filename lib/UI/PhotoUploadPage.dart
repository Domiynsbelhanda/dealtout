import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'HomePage.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-2474010233453501~8206756914';
const String AD_MOB_AD_ID = 'ca-app-pub-2474010233453501/1425085514';

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
  String url;
  String _value = "Autres";
  String _article;
  final formKey = new GlobalKey<FormState>();

  /*InterstitialAd myInterstitial;

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
  }*/

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
    final Reference postImageRef = FirebaseStorage.instance.ref().child("Datas");

      var timeKey = new DateTime.now();

      final TaskSnapshot uploadTask = await postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);

      var ImageUrl = await uploadTask.ref.getDownloadURL();

      url = ImageUrl.toString();
      saveToDatabase(url);
      //myInterstitial = buildInterstitialAd()..load();
      //myInterstitial..show();
      goToHomePage();
  });
}

  void saveToDatabase(url) async{
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('d MMM, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    var uuid = Uuid();

    String uid = uuid.v1();
    
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = await auth.currentUser;
    final uids = user.uid;

    var data={
      "key": uids.toString(),
      "article": _article,
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
      "prix": _prix,
      "categorie": _value,
      "vendue": false,
      "timestamp": FieldValue.serverTimestamp(),
      "id": uid
    };

    final FirebaseFirestore firestore = FirebaseFirestore.instance; 
    firestore.collection("Article").doc(uid).set(data);
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
    //FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);

    //myInterstitial = buildInterstitialAd()..load();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronCircleLeft,
            color: Colors.black
          ),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text(
          "Publication d'article",
          style: TextStyle(color: Colors.black)
          )
      ),

      body: new Center
      (
        child: sampleImage == null ? 
        Text("Selectionner une image"): 
        Padding(
          padding: EdgeInsets.all(15.0),
          child: enableUpload()),
      ),

      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: sampleImage == null ? getImage : null,
        tooltip: 'Ajouter une image',
        child: sampleImage == null ? new Icon(
          FontAwesomeIcons.solidImages,
          color: Colors.black
          ) : null,
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

          TextFormField(
            decoration: new InputDecoration(labelText: 'Article'),

            validator: (value){
              return value.isEmpty ? 'Le nom de l\'article est requise' : null;
            },

            onSaved: (value){
              return _article = value;
            },
          ),

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

          SizedBox(height: 15.0),

          DropdownButton<String>(
            items: [
                    DropdownMenuItem<String>(child: Row(
                      children: <Widget>[
                        Icon(Icons.all_inclusive),
                        SizedBox(width:5.0),
                        Text("Autres", 
                        style: new TextStyle(fontSize: 20.0, color: Colors.black))]),
                        value: "Autres"),

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
                        Text("Autres", 
                        style: new TextStyle(fontSize: 20.0, color: Colors.black))]),
                        value: "Autres"),
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