import 'package:flutter/material.dart';
import 'package:flutter_firebase_catbox/ui/cat_list.dart';

void main() => runApp(CatBoxApp());

class CatBoxApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pinkAccent,
        fontFamily: 'Ubuntu'
      ),
      home: CatListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}