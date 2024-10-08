import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.blue, 
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.withOpacity(.8),
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
  ),
  // textTheme: const TextTheme(
  //   headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
  //   headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
  //   headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
  //   bodyText1: TextStyle(fontSize: 16.0, color: Colors.black87),
  //   bodyText2: TextStyle(fontSize: 14.0, color: Colors.black54),
  //   caption: TextStyle(fontSize: 12.0, color: Colors.grey),
  // ),
  cardTheme: CardTheme(
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    elevation: 4.0,
    color: Colors.white, // Card background color
  ),
);
