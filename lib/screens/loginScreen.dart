import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/screens/create_wish_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Image(image: AssetImage('assets/img/reading.png')),

              Text(
                'Bienvenid@ a Letter',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w300
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 60),
                child: Text(
                  'Una comunidad de lectoras y lectores donde nos prestamos libros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),

              OutlineButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                highlightElevation: 0,
                borderSide: BorderSide(color: Colors.grey),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("assets/img/google_logo.png"), height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Ingresá con Google',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Lato',
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                onPressed: () async {
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
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => CreateWishListScreen()),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
