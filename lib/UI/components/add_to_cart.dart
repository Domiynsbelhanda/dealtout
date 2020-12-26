import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({
    Key key,
    @required this.product,
    @required this.users
  }) : super(key: key);

  final Products product;
  final Users users;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.greenAccent,
                onPressed: () async {
                  String url = 'tel:'+users.telephone;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Icon(
                  FontAwesomeIcons.phoneSquareAlt,
                  color: Colors.white,
                )
              ),

              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.grey,
                onPressed: () async {
                  String url = 'sms:'+users.telephone;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Icon(
                  FontAwesomeIcons.sms,
                  color: Colors.black,
                )
              ),

              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: Colors.blueAccent,
                onPressed: () async {
                  String url = 'mailito:'+users.email;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Icon(
                  FontAwesomeIcons.envelopeSquare,
                  color: Colors.white,
                )
              ),

        ],
      ),
    );
  }
}
