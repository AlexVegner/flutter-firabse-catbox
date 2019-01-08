import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_catbox/models/cat.dart';
import 'package:flutter_firebase_catbox/services/api.dart';
import 'package:flutter_firebase_catbox/ui/cat_details/details_page.dart';
import 'package:flutter_firebase_catbox/utils/routes.dart';
import 'dart:async';

class CatListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CatListPageState();
  }
}

class _CatListPageState extends State<CatListPage> {

  CatApi _catApi;
  NetworkImage _profileImage;

  List<Cat> _cats = [];

  @override
  void initState() {
    super.initState();
    //_loadCats();
    _loadFtomFirebase();
  }

   _loadFtomFirebase() async {
    final api = await CatApi.signInWithGoogle(); 
    final cats = await api.getAllCats();
    setState(() {
      _catApi = api;
      _profileImage = NetworkImage(_catApi.firebaseUser.photoUrl);
      _cats = cats;
    });
  }

  // _loadCats() async {
  //   String fileData = await DefaultAssetBundle.of(context).loadString('assets/cats.json');
  //   setState(() {
  //     _cats = CatApi.allCatsFromJson(fileData);   
  //   });
  //   print(_cats.toString());
  // }
  _reloadCats() async {
    if (_catApi != null) {
      final cats = await _catApi.getAllCats();
      setState(() {
        _cats = cats;
      });
    }
  }

  _navigateToCatDetails(Cat cat, Object avatarTag) {
    Navigator.of(context).push(
      FadePageRoute(
        builder: (c) {
          return CatDetailsPage(cat, avatarTag: avatarTag);
        },
        settings: RouteSettings(),
      )
    );
  }


  Widget _getAppTitleWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 5),
      child: Text(
        'Cats',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 32.0,
        ),
      ),
    );
  }

  Future<Null> _refresh() {
    _reloadCats();
    return Future<Null>.value();
  }

  Widget _getListViewWidget() {
    return Flexible(
      child: RefreshIndicator(
       onRefresh: _refresh,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: _cats.length,
          itemBuilder: _getListItemWidget,
        ),
      ),
    );
  }

   Widget _getListItemWidget(BuildContext context, int index){
    Cat cat = _cats[index]; 

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: () => _navigateToCatDetails(cat, index),
              leading: Hero(
                tag: index,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(cat.avatarUrl),
                ),
              ),
              title: Text(
                cat.name,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)
              ),
              subtitle: Text(cat.description),
              isThreeLine: true,
              dense: false,
            )
          ],
        ),
      ),
    );



    // return ListTile(
    //   title: Text(
    //     cat.name,
    //     style: TextStyle(
    //       color: Colors.white,
    //       fontSize: 20.0,
    //     ),
    //   ),
    // );
  }
  
  Widget _buidlBody() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 56, 8, 0),
      child: Column(
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _buidlBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: _catApi != null ? 'Signed-in: ${_catApi.firebaseUser.displayName}' : 'Not Signed-in',
        backgroundColor: Colors.blue,
        child: CircleAvatar(
          backgroundImage: _profileImage,
          radius: 50,
        ),
      ),
    );
  }
}
