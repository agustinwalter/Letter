import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';
import 'package:letter/screens/create_wish_list_screen.dart';
import 'package:letter/screens/logged_screen.dart';
import 'package:letter/screens/loginScreen.dart';
// import 'package:flutter/rendering.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // debugPaintSizeEnabled=true;
  return runApp(Letter());
}

class Letter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Screens()
    );
  }
}

class Screens extends StatefulWidget {
  @override
  _ScreensState createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  String screenToShow = '';

  @override
  initState() {
    super.initState();
    
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.currentUser().then((FirebaseUser currentUser) {
      if(currentUser != null){
        if(currentUser.isEmailVerified){
          Firestore.instance.document('users/${currentUser.uid}').get()
          .then((DocumentSnapshot snap) {
            if(snap.data.containsKey('wishList')){
              // El usuario está loggeado y creo su lista de deseos
              setState(() => screenToShow = 'LOGGED');
            }else{
              // El usuario está loggeado y no creo su lista de deseos
              setState(() => screenToShow = 'CREATE_WISH_LIST');
            }
          });
        }else{
          // El usuario no está loggeado
          setState(() => screenToShow = 'LOGIN');
        }
      }else{
        // El usuario no está loggeado
        setState(() => screenToShow = 'LOGIN');
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return LoggedScreen();
    // return ConditionalSwitch.single<String>(
    //   context: context,
    //   valueBuilder: (BuildContext context) => screenToShow,
    //   caseBuilders: {
    //     'LOGIN': (BuildContext context) => LoginScreen(),
    //     'CREATE_WISH_LIST': (BuildContext context) => CreateWishListScreen(),
    //     'LOGGED': (BuildContext context) => LoggedScreen(),
    //   },
    //   fallbackBuilder: (BuildContext context) => CupertinoPageScaffold(child: SizedBox.shrink()),
    // );
  }
}

// class CreateAccountScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       child: ListView(
//         padding: EdgeInsets.all(20),
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Image(image: AssetImage('assets/img/login.png')),
//               ),

//               Text(
//                 'Creá una cuenta',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontFamily: 'Lato',
//                   fontWeight: FontWeight.w300
//                 ),
//               ),

//               Padding(
//                 padding: const EdgeInsets.only(top: 15),
//                 child: CupertinoTextField(
//                   keyboardType: TextInputType.text,
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26),
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   placeholder: 'Tu nombre',
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 15),
//                 child: CupertinoTextField(
//                   keyboardType: TextInputType.emailAddress,
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26),
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   placeholder: 'Tu email',
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 15),
//                 child: CupertinoTextField(
//                   keyboardType: TextInputType.visiblePassword,
//                   obscureText: true,
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26),
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   placeholder: 'Una contraseña',
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 15),
//                 child: CupertinoTextField(
//                   keyboardType: TextInputType.visiblePassword,
//                   obscureText: true,
//                   padding: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black26),
//                     borderRadius: BorderRadius.all(Radius.circular(8)),
//                   ),
//                   placeholder: 'Repetí la contraseña',
//                 ),
//               ),

//               SizedBox(height: 20),

//               CupertinoButton(
//                 color: Color(0xff007aff),
//                 child: Text('Crear cuenta'), 
//                 onPressed: (){}
//               ),

//               CupertinoButton(
//                 child: Text('Volver al inicio'), 
//                 onPressed: () => Navigator.pop(context)
//               )

//             ],
//           )
//         ],
//       )
//     );
//   }
// }