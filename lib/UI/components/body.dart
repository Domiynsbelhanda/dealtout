import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:flutter/material.dart';

import 'add_to_cart.dart';
import 'product_title_with_image.dart';

class Body extends StatelessWidget {
  final Products product;
  final Users users;

  const Body({Key key, this.product, this.users}) : super(key: key);
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
                      
                      Text(
                          "Publier par : " + users.name,
                          style: TextStyle(),
                        ),

                      SizedBox(height: 5.0),
                      AddToCart(product: product, users: users)
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
