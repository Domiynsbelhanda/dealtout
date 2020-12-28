import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  final String image, title, description;
  final int price, size, id;
  final Color color;
  Product({
    this.id,
    this.image,
    this.title,
    this.price,
    this.description,
    this.size,
    this.color,
  });
}

class Products{
  final String article, categorie, date, description, id, image, key, prix, time;
  final Timestamp timestamp;

  Products({this.article, this.categorie, this.date, this.description, this.id, this.image, this.key, this.prix, this.time, this.timestamp});
}

class Users{
  final String email, key, name, telephone;

  Users({this.email, this.key, this.name, this.telephone});
}

List<Products> products = [
  Products(
      article: "Office Code",
      categorie: "Article",
      prix: "234",
      date: "23 Déc, 2020",
      description: dummyText,
      image: "assets/images/bag_1.png",
      id: "No Id",
      key: "No key",
      time: "No times"
    )
];

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
