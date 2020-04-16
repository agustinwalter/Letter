import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter/globals.dart' as globals;

class UserModel with ChangeNotifier {
  FirebaseUser user;
  Map<dynamic, dynamic> userData;
  Firestore db = Firestore.instance;

  Future initUser() {
    return FirebaseAuth.instance.currentUser().then((u) {
      user = u;
      if(user != null){
        db.document('users/${user.email}').snapshots().listen((DocumentSnapshot doc){
          if(doc.exists) userData = doc.data;
          else userData = null;
          notifyListeners();
          return userData;
        });
      }else{
        return null;
      }
    });
  }

  Future reloadUser() => user.reload().then((res) => initUser().then((res) => 'user-reloaded'));

  void updateUser(FirebaseUser u) => user = u;

  FirebaseUser getUser() => user;

  String getUserEmail() {
    if(user == null) return '';
    return user.email;
  }

  String getUserName() {
    if(user == null) return '';
    return user.displayName;
  }

  String getBookRentedLink() {
    if(userData == null) return null;
    return userData['book_link'];
  }
  
  String getBookRentedStatus() {
    if(userData == null) return null;
    return userData['book_status'];
  }

  String getSubscriptionStatus(){
    if(userData == null) return null;
    return userData['subs_status'];
  }

  // String getSubscriptionId(){
  //   if(userData == null) return null;
  //   return userData['subs_id'];
  // }

  Map<dynamic, dynamic> getAddress(){
    if(userData == null) return null;
    return userData['address'];
  }

  bool addedAddress(){
    if(userData == null) return false;
    if(userData['address'] == null) return false;
    return true;
  }

  void rentBook(String bookLink){
    db.document('users/${user.email}').updateData({
      'book_link': bookLink,
      'book_status': 'PENDING_APPROVAL'
    });
  }

  void cancelRentBook(){
    db.document('users/${user.email}').updateData({
      'book_link': FieldValue.delete(),
      'book_status': FieldValue.delete()
    });
  }

  void updateBookStatus(String status){
    db.document('users/${user.email}').updateData({
      'book_status': status
    });
  }

  void closeSession(){
    FirebaseAuth.instance.signOut();
    user = null;
    userData = null;
    notifyListeners();   
  }

  Future login(String email, String password){
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    ).then((AuthResult authResult) => initUser()
    ).catchError((error){
      switch (error.code) {
        case 'ERROR_USER_NOT_FOUND': return 'ERROR_USER_NOT_FOUND';
        case 'ERROR_INVALID_EMAIL': return 'ERROR_INVALID_EMAIL';
        case 'ERROR_WRONG_PASSWORD': return 'ERROR_WRONG_PASSWORD';
        case 'ERROR_USER_DISABLED': return 'ERROR_USER_DISABLED';
        case 'ERROR_TOO_MANY_REQUESTS': return 'ERROR_TOO_MANY_REQUESTS';
        case 'ERROR_OPERATION_NOT_ALLOWED': return 'ERROR_OPERATION_NOT_ALLOWED';
        default: return null;
      }
    });
  }

  Future register(String email, String password, String username){
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    ).then((AuthResult authResult) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = username;
      return authResult.user.updateProfile(userUpdateInfo)
      .then((res) => authResult.user.sendEmailVerification()
      .then((res) {
        return initUser().then((res){
          return 'EMAIL_VERIFICATION_SENDED';
        });
      }));
    }).catchError((error){
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD': return 'ERROR_WEAK_PASSWORD';
        case 'ERROR_INVALID_EMAIL': return 'ERROR_INVALID_EMAIL';
        case 'ERROR_EMAIL_ALREADY_IN_USE': return 'ERROR_EMAIL_ALREADY_IN_USE';
        default: return null;
      }
    });
  }

  bool isEmailVerified(){
    if(user == null) return false;
    return user.isEmailVerified;
  }
  
  Future updateAddress(Map<String, String> address){
    if(user == null) return null;
    return Firestore.instance.document('users/${user.email}').get().then((DocumentSnapshot d){
      if(d.exists){
        return Firestore.instance.document('users/${user.email}')
        .updateData({
          'address': address,
          'subs_status': 'PENDING'
        }).then((res) => 'PENDING_APPROVAL');
      }else{
        return Firestore.instance.document('users/${user.email}')
        .setData({
          'address': address,
          'subs_status': 'PENDING'
        }).then((res) => 'PENDING_APPROVAL');
      }
    });
  }

  bool offerFreeTrial(){
    if(user == null) return null;
    if(userData == null) return null;
    return userData['offer_free_trial'];
  }

  Future updateSubscription(String status){
    // Me envío un email
    http.post('${globals.baseUrl}/api/v1/users/send-email', body: {
      'subject': 'Actualizaron una suscripción',
      'email_message': 'El usuario ${user.email} actualizó su suscripción al estado $status.'
    });
    return Firestore.instance.document('users/${user.email}')
    .updateData({
      'subs_status': status
    }).then((res) => status);
  }

}