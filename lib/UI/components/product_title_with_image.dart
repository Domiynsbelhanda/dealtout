import 'package:DEALTOUT/Styles/Constants.dart';
import 'package:DEALTOUT/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Products product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.categorie,
            style: TextStyle(color: Colors.black),
          ),
          Text(
            product.article,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: kDefaultPaddin),
          Center(
            child:
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      product.image,
                      height: 150.0,
                      width: 110.0,
                      fit: BoxFit.cover
                  ),
              )
          ),

          SizedBox(height: 10.0),

          Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            padding: EdgeInsets.all(3.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Prix: " + product.prix,
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontSize: 15.0,
                  )
                ),

                Text(
                  product.date,
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontSize: 15.0,
                  )
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}
