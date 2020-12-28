import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Products product;
  final Users users;

  const DetailsScreen({Key key, this.product, this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Body(product: product, users: users),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.chevronCircleLeft,
            color: Colors.black
          ),
          onPressed: ()=> Navigator.pop(context),
        ),
    );
  }
}
