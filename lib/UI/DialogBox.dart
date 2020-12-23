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

void showInSnackBar(String value, _scaffoldKey, context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }