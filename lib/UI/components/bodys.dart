import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../HomePage.dart';
import 'add_to_cart.dart';
import 'product_title_with_image.dart';

class Bodys extends StatelessWidget {
  final Products product;
  final Users users;

  const Bodys({Key key, this.product, this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 15.0,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      ProductTitleWithImage(product: product),
                      SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
                        child: Text(
                          product.description,
                          style: TextStyle(height: 1.5),
                        ),
                      ),

                      SizedBox(height: 5.0),
                      Text(
                        "Si vous supprimez, il y a pas de retour en arrière possible."
                      ),
                      Center(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          color: Colors.white,
                          onPressed: () async {
                            final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                            await
                            _firestore.collection('Article').doc(product.id).delete();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                            ));
                          },
                          child: Icon(
                            FontAwesomeIcons.trash,
                            color: Colors.red,
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
