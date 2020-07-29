import 'dart:async';
import 'dart:io';
import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class User extends ChangeNotifier {
  bool isLoading = true;
  FirebaseUser data;
  Map<String, dynamic> dataV = {};
  List<Map<String, dynamic>> booksToLend;
  Map<String, dynamic> lendUserInfo = {'name': '', 'reputation': 0};
  List opinions = [];
  List<Map<String, dynamic>> profileCards = [];
  CubeUser cubeUser;
  StreamSubscription<DocumentSnapshot> listenDatabase;

  initUser({FirebaseUser user}) async {
    FirebaseUser currentUser = user;
    if (currentUser == null)
      currentUser = await FirebaseAuth.instance.currentUser();
    // El usuario no está loggeado
    if (currentUser == null) {
      isLoading = false;
      notifyListeners();
      return;
    }
    // El usuario está loggeado
    data = currentUser;

    // Inicio el chat
    // initChat();

    // Inicio las notificaciones
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async =>
          print("onMessage: $message"),
      onLaunch: (Map<String, dynamic> message) async =>
          print("onLaunch: $message"),
      onResume: (Map<String, dynamic> message) async =>
          print("onResume: $message"),
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    DocumentReference doc = Firestore.instance.document('users/${data.uid}');
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      DocumentSnapshot snap = await doc.get();
      snap.exists
          ? doc.updateData({'subsToken': token})
          : doc.setData({'name': data.displayName, 'subsToken': token});
    });

    listenDatabase = doc.snapshots().listen((DocumentSnapshot snap) async {
      if (!snap.exists) {
        doc.setData({'name': data.displayName});
        dataV = {
          'name': data.displayName,
          'money': '0',
          'image': '',
          'reputation': 0
        };
        profileCards.insert(0, {'type': 'add_photo'});
      } else {
        dataV = snap.data;
        if (!dataV.containsKey('money')) dataV['money'] = '0';
        if (!dataV.containsKey('image')) {
          dataV['image'] = '';
          profileCards.insert(0, {'type': 'add_photo'});
        } else {
          profileCards.removeAt(0);
          print(profileCards);
        }
        if (!dataV.containsKey('reputation')) dataV['reputation'] = 0;
      }
      isLoading = false;
      notifyListeners();
    });
  }

  endApp() {
    if (listenDatabase != null) listenDatabase.cancel();
  }

  login() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
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
    initUser(user: currentUser);
  }

  createWishList(List<Map<String, String>> books) async {
    DocumentSnapshot snap =
        await Firestore.instance.document('users/${data.uid}').get();
    if (snap.exists) {
      await Firestore.instance
          .document('users/${data.uid}')
          .updateData({'wishList': FieldValue.arrayUnion(books)});
    } else {
      await Firestore.instance
          .document('users/${data.uid}')
          .setData({'wishList': FieldValue.arrayUnion(books)});
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
    await Firestore.instance
        .document('users/${data.uid}')
        .updateData({'location': location});
  }

  getBooksToLend() async {
    // Busco a todos los usuarios que agregaron ubicación
    QuerySnapshot users = await Firestore.instance
        .collection('users')
        .orderBy('location')
        .getDocuments();
    for (DocumentSnapshot user in users.documents) {
      // Si el usuario no soy yo, tiene lista de deseos...
      if (user.documentID != data.uid && user.data['wishList'].length > 0) {
        double myLat = dataV['location']['lat'];
        double myLon = dataV['location']['lon'];
        double lat = user.data['location']['lat'];
        double lon = user.data['location']['lon'];
        double distanceInMeters =
            await Geolocator().distanceBetween(myLat, myLon, lat, lon);
        // ...y vive a menos de 20km
        if (distanceInMeters < 20000) {
          // Agrego sus libros a la lista
          if (booksToLend == null) booksToLend = [];
          for (var book in user.data['wishList']) {
            Map<String, dynamic> bookWD = {
              'title': book['title'],
              'author': book['author'],
              'uid': user.documentID,
              'distance': distanceInMeters
            };
            booksToLend.add(bookWD);
          }
        }
        notifyListeners();
      } else {
        if (booksToLend == null) booksToLend = [];
        notifyListeners();
      }
    }
  }

  getLendUserInfo(String lendUserId, double distance) async {
    lendUserInfo = {'name': '', 'reputation': 0, 'distance': 0};

    DocumentSnapshot doc =
        await Firestore.instance.document('users/$lendUserId').get();
    if (doc.exists) {
      String image;
      int reputation = 0;
      if (doc.data['image'] != null) image = doc.data['image'];
      if (doc.data['reputation'] != null) reputation = doc.data['reputation'];
      lendUserInfo = {
        'name': doc.data['name'].split(' ')[0],
        'image': image,
        'reputation': reputation,
        'distance': distance.round()
      };
    }

    notifyListeners();
  }

  getOpinions(String uid) async {
    opinions = [];
    QuerySnapshot snap = await Firestore.instance
        .collection('opinions')
        .where('to', isEqualTo: uid)
        .getDocuments();
    for (DocumentSnapshot doc in snap.documents) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(
          doc.data['date'].millisecondsSinceEpoch);
      String date = timeago.format(time, locale: 'es');
      date = '${date[0].toUpperCase()}${date.substring(1)}';
      opinions.add({
        'name': doc.data['name'],
        'opinion': doc.data['opinion'],
        'type': doc.data['type'],
        'date': date
      });
    }
    notifyListeners();
  }

  // getProfileCards() {
  //   profileCards.addAll([
  //     {'type': 'reputation', 'status': 0},
  //     {'type': 'configuration'}
  //   ]);
  // profileCards = [
  //   {'type': 'reputation', 'status': 0},
  //   {'type': 'configuration'}
  // ];

  // if (dataV['image'] == '') profileCards.insert(0, {'type': 'add_photo'});

  // Future.delayed(Duration(milliseconds: 1000), () {
  //   profileCards = [
  //     {
  //       'type': 'delivery',
  //       'status': 'pre_delivery',
  //       'book': 'A Sangre Fría',
  //       'name': 'María'
  //     },
  //     {
  //       'type': 'received',
  //       'status': 'received',
  //       'book': 'Cien Años De Soledad',
  //       'author': 'Larralde',
  //       'uid': 'uid',
  //       'name': 'José'
  //     },
  //     {'type': 'reputation', 'status': 0}
  //   ];
  // notifyListeners();
  // });
  // }

  Stream<StorageTaskEvent> uploadImage(File image, context) {
    final FirebaseStorage storage =
        FirebaseStorage(storageBucket: 'gs://letter-bfbab.appspot.com');
    StorageUploadTask uploadTask;
    String path = 'profilePics/${data.uid}.jpg';
    uploadTask = storage.ref().child(path).putFile(image);
    uploadTask.onComplete.then((value) async {
      String url = await value.ref.getDownloadURL();
      await Firestore.instance
          .document('users/${data.uid}')
          .updateData({'image': url});
      profileCards.removeAt(0);
      Navigator.pop(context, true);
    });
    return uploadTask.events;
  }

  deleteImage() async {
    final FirebaseStorage storage =
        FirebaseStorage(storageBucket: 'gs://letter-bfbab.appspot.com');
    String path = 'profilePics/${data.uid}.jpg';
    await storage.ref().child(path).delete();
    Firestore.instance
        .document('users/${data.uid}')
        .updateData({'image': FieldValue.delete()});
  }

  Future<DocumentSnapshot> checkLendBook(
      String uid, String bookName, String bookAuthor, bool receiving) async {
    // Busco los libros que le presté
    QuerySnapshot snap;
    if (receiving) {
      snap = await Firestore.instance
          .collection('lendedBooks')
          .where('from', isEqualTo: uid)
          .where('to', isEqualTo: data.uid)
          .getDocuments();
    } else {
      snap = await Firestore.instance
          .collection('lendedBooks')
          .where('to', isEqualTo: uid)
          .where('from', isEqualTo: data.uid)
          .getDocuments();
    }
    if (snap.documents.length == 0) {
      // Si no hay, se lo presto
      return await lendBook(uid, bookName, bookAuthor);
    } else {
      // Si hay, veo si es el mismo de ahora
      DocumentSnapshot doc;
      for (DocumentSnapshot d in snap.documents) {
        if (bookName == d.data['bookName'] &&
            bookAuthor == d.data['bookAuthor']) {
          doc = d;
          break;
        }
      }
      // Si no es, se lo presto
      if (doc == null)
        return await lendBook(uid, bookName, bookAuthor);
      else
        return doc;
    }
  }

  Future<DocumentSnapshot> lendBook(
      String uid, String bookName, String bookAuthor) async {
    DocumentReference doc =
        await Firestore.instance.collection('lendedBooks').add({
      'from': data.uid,
      'to': uid,
      'deliveryDate': DateTime.now(),
      'receivedDate': null,
      'bookName': bookName,
      'bookAuthor': bookAuthor,
      'status': 0,
      'opinionId': null
    });
    return await doc.get();
  }

  initChat() async {
    // Inicio el chat
    String appId = '2777';
    String authKey = 'OUSWkuBsezgb6ne';
    String authSecret = 'rK-GLPa9U6FsbSJ';
    init(appId, authKey, authSecret);
    CubeSettings.instance.isDebugEnabled = false;
    try {
      // Logeo al usuario
      await createSession();
      try {
        await getUserByLogin(data.uid);
      } catch (e) {
        await signUp(CubeUser(login: data.uid, password: data.uid));
      }
      cubeUser = await signIn(CubeUser(login: data.uid, password: data.uid));
      await CubeChatConnection.instance
          .login(CubeUser(id: cubeUser.id, password: data.uid));
    } catch (e) {
      print('ERROR');
      print(e);
    }
  }

  Future<String> getNotificationToken(String uid) async {
    DocumentSnapshot doc =
        await Firestore.instance.document('users/$uid').get();
    if (doc.exists) return doc.data['subsToken'];
    return null;
  }
}

class UserData{
  // Datos obtenidos de Firebase Auth
  // displayName [String]
  // photoUrl [String - null]
  // email [String]
  // uid [String]

  // Datos obtenidos de Firestore, colección users (documentId = uid)
  // displayName (Obtenido de Firebase Auth) [String]
  // photoUrl (Obtenido de Firebase Auth) [String - undefined]
  // reputation [Number - undefined]
}

class Book{
  // title
  // author
  // geohash
  // status
  // uid
}

class Opinion{
  // message
  // date
  // type
  // fromName
  // fromUid
  // toUid
}