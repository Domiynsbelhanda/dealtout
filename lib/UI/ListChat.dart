import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ChatBody.dart';
import '../Util/Posts.dart';

class ChatBody extends StatefulWidget{
  static const String id = "CHAT";
  String keys;

  ChatBody({Key key, this.keys}) : super(key: key);
  @override
  _ChatState createState() => _ChatState(keys: keys);
}

class _ChatState extends State<ChatBody>{
  String keys;
  _ChatState({this.keys});
  final Firestore _firestore = Firestore.instance;
  List<Posts> postsList;

  String datas, datas2, datas3;
  var uid;
  String keyAA;

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

          if(datas == keys || datas == keys){
            uid = doc.documentID;
          }
        });
        }));
      print(datas);
  }

  Future<void> callback() async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context){
        return new Chat(
          keyDe: keys,
          keyA: keyAA,
          keyDisc: null,
        );
      }));
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
                          .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData) return const Text('En cours de chargement ...');
                  final int messageCount = snapshot.data.documents.length;
                  return ListView.builder(
                    itemCount: messageCount,
                    itemBuilder: (_, int index){
                      final DocumentSnapshot document = snapshot.data.documents[index];
                      if (document['de'] == keys){
                        keyAA = document['a'];
                        return Container(
                        alignment: Alignment.topLeft, 
                        child: 
                                Card(
                                  color: Colors.white
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
                                    padding: new EdgeInsets.all(15.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document['a'] + '\n Anonyme chat',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.blueGrey
                                            ),
                                          ),
                                          SizedBox(width: 10.0,),
                                          SendButton(
                                            text: "Voir",
                                            callback: callback,
                                          )
                                        ],
                                      )
                                    )
                                  )
                      );
                      }
                    },
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class SendButton extends StatelessWidget{
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super (key: key);

  @override
  Widget build(BuildContext context){
    return FlatButton(
      color: Colors.blueGrey,
      onPressed: callback,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0
        ),
      ),
    );
  }
}