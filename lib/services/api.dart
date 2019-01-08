import 'dart:async';
import 'dart:convert';
import 'package:flutter_firebase_catbox/models/cat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CatApi {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn =GoogleSignIn();

  FirebaseUser firebaseUser;

  CatApi(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<CatApi> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleOuth = await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleOuth.accessToken,
      idToken: googleOuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser(); 
    assert(user.uid == currentUser.uid);
    return CatApi(user);
  }



  static List<Cat> allCatsFromJson(String jsonData) {
    List<Cat> cats = [];
    json.decode(jsonData)['cats'].forEach((cat) => cats.add(_forMap(cat)));
    return cats;
  }

  Future<List<Cat>> getAllCats() async {
    return (await Firestore.instance.collection('cats').getDocuments())
      .documents
      .map((snapshot) => _fromDocumentSnapshot(snapshot))
      .toList();
  }

  StreamSubscription watch(Cat cat, void onChange(Cat cat)) {
    return Firestore.instance
      .collection('cats')
      .document(cat.documentId)
      .snapshots()
      .listen((snapshot) => onChange(_fromDocumentSnapshot(snapshot)));
  } 

  static Cat _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;
    return Cat(
      documentId: snapshot.documentID,
      externalId: data['id'],
      name: data['name'],
      description: data['description'],
      avatarUrl: data['image_url'],
      location: data['location'],
      likeCounter: data['like_counter'],
      isAdopted: data['adopted'],
      pictures: List<String>.from(data['pictures']),
      cattributes: List<String>.from(data['cattributes']),
    );
  }

  static Cat _forMap(Map<String, dynamic> map) {
    return Cat(
      externalId: map['id'],
      name: map['name'],
      description: map['description'],
      avatarUrl: map['image_url'],
      location: map['location'],
      likeCounter: map['like_counter'],
      isAdopted: map['adopted'],
      pictures: List<String>.from(map['pictures']),
      cattributes: List<String>.from(map['cattributes']),
    );
  }

  Future likeCat(Cat cat) async {
    await Firestore.instance
        .collection('likes')
        .document('${cat.documentId}:${this.firebaseUser.uid}')
        .setData({});
  }

  Future unlikeCat(Cat cat) async {
    await Firestore.instance
        .collection('likes')
        .document('${cat.documentId}:${this.firebaseUser.uid}')
        .delete();
  }

  Future<bool> hasLikedCat(Cat cat) async {
    final like = await Firestore.instance
        .collection('likes')
        .document('${cat.documentId}:${this.firebaseUser.uid}')
        .get();

    return like.exists;
  }
}