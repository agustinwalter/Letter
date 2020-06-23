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
  Map<String, dynamic> lendUserInfo = {
    'name': '',
    'reputation': 0
  };
  List opinions = [];
  List profileCards = [];

  init({FirebaseUser user}) async {
    FirebaseUser currentUser = user;
    if(currentUser == null){
      final FirebaseAuth _auth = FirebaseAuth.instance;
      currentUser = await _auth.currentUser();
    }
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
      if(snap.exists){
        dataV = snap.data;
        if(!dataV.containsKey('money')) dataV['money'] = '0';
        if(!dataV.containsKey('image')) dataV['image'] = '';
        if(!dataV.containsKey('reputation')) dataV['reputation'] = 0;
      }
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
    init(user: currentUser);
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
    // Busco a todos los usuarios que agregaron ubicación
    QuerySnapshot users = await Firestore.instance.collection('users').orderBy('location').getDocuments();
    for (DocumentSnapshot user in users.documents) {
      // Si el usuario no soy yo, tiene lista de deseos...
      if(user.documentID != data.uid && user.data['wishList'].length > 0){
        double myLat = dataV['location']['lat'];
        double myLon = dataV['location']['lon'];
        double lat = user.data['location']['lat'];
        double lon = user.data['location']['lon'];
        double distanceInMeters = await Geolocator().distanceBetween(myLat, myLon, lat, lon);
        // ...y vive a menos de 20km
        if(distanceInMeters < 20000){
          // Agrego sus libros a la lista
          if(booksToLend == null) booksToLend = [];
          for (var book in user.data['wishList']) { 
            Map<String, dynamic> bookWD = {
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

  getLendUserInfo(){
    lendUserInfo = {
      'name': '',
      'reputation': 0,
      'distance': 0
    };
    Future.delayed(Duration(milliseconds: 500), () {
      lendUserInfo = {
        'name': 'María',
        'image': 'https://www.laprensa.hn/csp/mediapool/sites/dt.common.streams.StreamServer.cls?STREAMOID=EPvuNX15N56wxlEpiUYw4c\$daE2N3K4ZzOUsqbU5sYsVkWrnOtsMWQvXhFzoKc7f6FB40xiOfUoExWL3M40tfzssyZqpeG_J0TFo7ZhRaDiHC9oxmioMlYVJD0A\$3RbIiibgT65kY_CSDiCiUzvHvODrHApbd6ry6YGl5GGOZrs-&CONTENTTYPE=image/jpeg',
        'reputation': 3,
        'distance': 18344
      };
      notifyListeners();
    });
  }

  getOpinions(){
    opinions = [];
    Future.delayed(Duration(milliseconds: 1000), () {
      opinions = [
        {
          'name': 'Agustín Walter',
          'opinion': 'Muchas gracias por el trabajo realizado y por la paciencia. Profesionales, eficientes, rápidos y flexibles en las necesidades, son las características que definen a este gran equipo.',
          'type': 2,
          'date': 'Hace 2 semanas'
        },
        {
          'name': 'Rodrigo Gauna',
          'opinion': 'Muchas gracias por el trabajo realizado y por la paciencia.',
          'type': 1,
          'date': 'Hace 3 meses'
        },
        {
          'name': 'Sofía Walter',
          'opinion': 'Profesionales, eficientes, rápidos y flexibles en las necesidades, son las características que definen a este gran equipo.',
          'type': 0,
          'date': 'Hace 1 año'
        },
      ];
      notifyListeners();
    });
  }

  getProfileCards(){
    profileCards = [];
    Future.delayed(Duration(milliseconds: 1000), () {
      profileCards = [
        {
          'type': 'add_photo'
        },
        {
          'type': 'delivery',
          'status': 'pre_delivery',
          'book': 'A Sangre Fría',
          'name': 'María'
        },
        {
          'type': 'received',
          'status': 'received',
          'book': 'Cien Años De Soledad',
          'name': 'José'
        },
        {
          'type': 'reputation',
          'status': 0
        },
        {
          'type': 'configuration',
        },
      ];
      notifyListeners();
    });
  }

}