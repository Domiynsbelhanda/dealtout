import 'package:flutter/material.dart';

class About extends StatefulWidget{

  @override
  State <StatefulWidget> createState() {
    return _About();
  }
}

class _About extends State<About>{

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: Column(
            children: <Widget>[
              Text(
                "DEAL TOUT 1.0.0"
              )
            ],
          )
      ),
    );
  }
}