import 'package:flutter/material.dart';

class DialogBox{

  information(BuildContext context, String title, String description){
    return showDialog(
      context: context,
      barrierDismissible: true,

      builder:(context){
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
                SizedBox(height: 10.0),
                Text("Cliquez a coté.")
              ],
            ),
          ),

          actions: <Widget>[
            
          ],
        );
      }
    );
  }
}