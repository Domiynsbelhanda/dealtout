import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat extends StatefulWidget{
  static const String id = "CHAT";
  String keyDe;
  String keyA;
  String keyDisc;

  Chat({Key key, this.keyDe, this.keyA, this.keyDisc}) : super(key: key);
  @override
  _ChatState createState() => _ChatState(keyDe: keyDe, keyA: keyA, keyDisc: keyDisc);
}

class _ChatState extends State<Chat>{
  String keyDe;
  String keyA;
  String keyDisc;
  _ChatState({this.keyDe, this.keyA, this.keyDisc});
  final Firestore _firestore = Firestore.instance;
  
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  String datas, datas2;
  var uid;
  String uidd;
  bool verifie = true;

  @override
  void initState(){
    super.initState();
    char();
  }

  void char() async{
    Firestore.instance
    .collection('message')
    .snapshots()
    .listen((data) =>
        data.documents.forEach((doc) { setState(() {
          datas = doc['a'];
          datas2 = doc['de'];

          if((datas == keyDe || datas == keyA) && (datas2 == keyDe || datas2 == keyA)){
            uid = doc.documentID;
          }
        });
        }));
  }

  Future<void> callback() async{

    Firestore.instance
    .collection('message')
    .snapshots()
    .listen((data) =>
        data.documents.forEach((doc) {
          datas = doc['a'];
          datas2 = doc['de'];

          if((datas == keyDe || datas == keyA) && (datas2 == keyDe || datas2 == keyA)){
            uid = doc.documentID;
            verifie = false;
          } else{
            verifie = true;
          };
        }));

    if (verifie) {
      var user = await FirebaseAuth.instance.currentUser();
      uidd = user.uid;
      uid = uidd;
      await
      _firestore.collection('message').document(uid).setData({
        'de': keyDe,
        'a': keyA,
      });
    };
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('d MMM, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    if(messageController.text.length > 0){
      await
      _firestore.collection('message').document(uid).collection('discussion').add({
        'text': messageController.text,
        'de': keyDe,
        'a': keyA,
        'heure': time,
        'date': date,
      });
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut);
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("DealTout Chat")
      ),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                          .collection("message")
                          .document(uid)
                          .collection('discussion')
                          .orderBy('heure', descending: true)
                          .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData) return const Text('En cours de chargement ...');
                  final int messageCount = snapshot.data.documents.length;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messageCount,
                    itemBuilder: (_, int index){
                      final DocumentSnapshot document = snapshot.data.documents[index];
                      final dynamic us = document['de'];
                      final dynamic message = document['text'];
                      return Container(
                        alignment: us == keyDe ?
                          Alignment.topRight : Alignment.topLeft, 
                        child: 
                                Card(
                                  color: us == keyDe ? 
                                    Colors.blueGrey : Colors.white
                                  ,
                                  elevation: 2.0,
                                  margin: EdgeInsets.all(10.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: new Radius.circular(20),
                                      topLeft: new Radius.circular(20),
                                      topRight: new Radius.circular(20),
                                    ),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width - 150,
                                    padding: new EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            message,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: us == keyDe ? 
                                                Colors.white : Colors.blueGrey
                                            ),
                                          ),
                                          SizedBox(height: 10.0),
                                          Text(
                                            document['heure'],
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: us == keyDe ? 
                                                Colors.white : Colors.blue
                                            ),
                                          )
                                        ],
                                      )
                                    )
                                  )
                      );
                        
                    },
                  );
                },
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) =>callback(),
                        decoration: InputDecoration(
                          hintText: "Entrez votre texte",
                        ),
                        controller: messageController,
                      )
                    ),
                    SendButton(
                      text: "Envoyer",
                      callback: callback,
                    )
                  ],
                ),
              )
            )
            
          ]
        ),
      ),
    );
  }

  chatList(DocumentSnapshot document, BuildContext context) {}

  chatList2(DocumentSnapshot document, BuildContext context) {}
}

class SendButton extends StatelessWidget{
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super (key: key);

  @override
  Widget build(BuildContext context){
    return FlatButton(
      onPressed: callback,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 17.0
        ),
      ),
    );
  }
}