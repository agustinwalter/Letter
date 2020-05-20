import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User extends ChangeNotifier {
  bool isLoading = true;
  FirebaseUser data;
  Map<String, dynamic> dataV = {};
  List<Map<String, dynamic>> booksToLend;

  init() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser currentUser = await _auth.currentUser();
    // El usuario no está loggeado
    if(currentUser == null){
      isLoading = false;
      notifyListeners();
      return;
    }
    // El usuario está loggeado
    data = currentUser;
    Firestore.instance.document('users/${currentUser.uid}')
    .snapshots().listen((DocumentSnapshot snap) {
      if(snap.exists) dataV = snap.data;
      isLoading = false;
      notifyListeners();
      return;
    });
  }

  login() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    init();
  }

  createWishList(List<Map<String, String>> books) async {
    DocumentSnapshot snap = await Firestore.instance.document('users/${data.uid}').get();
    if(snap.exists){
      await Firestore.instance.document('users/${data.uid}').updateData({
        'wishList': FieldValue.arrayUnion(books)
      });
    }else{
      await Firestore.instance.document('users/${data.uid}').setData({
        'wishList': FieldValue.arrayUnion(books)
      });
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    data = null;
    dataV = null;
    notifyListeners();
  }

  addBookToWishList(Map<String, String> book) {
    Firestore.instance.document('users/${data.uid}').updateData({
      'wishList': FieldValue.arrayUnion([book])
    });
  }

  removeBookFromWishList(Map<String, String> book) {
    Firestore.instance.document('users/${data.uid}').updateData({
      'wishList': FieldValue.arrayRemove([book])
    });
  }

  addLocation(Map<String, double> location) async {
    await Firestore.instance.document('users/${data.uid}').updateData({
      'location': location
    });
  }

  getBooksToLend() async {
    QuerySnapshot users = await Firestore.instance.collection('users').orderBy('location').getDocuments();
    for (DocumentSnapshot user in users.documents) {
      if(user.documentID != data.uid && user.data['wishList'].length > 0){
        double myLat = dataV['location']['lat'];
        double myLon = dataV['location']['lon'];
        double lat = user.data['location']['lat'];
        double lon = user.data['location']['lon'];
        double distanceInMeters = await Geolocator().distanceBetween(myLat, myLon, lat, lon);
        if(distanceInMeters < 20000){
          if(booksToLend == null) booksToLend = [];
          for (var book in user.data['wishList']) { 
            var bookWD = {
              'title': book['title'],
              'author': book['author'],
              'distance': distanceInMeters
            };
            booksToLend.add(bookWD); 
          }
        }
        notifyListeners();
      }else{
        if(booksToLend == null) booksToLend = [];
        notifyListeners();
      } 
    }
  }

}