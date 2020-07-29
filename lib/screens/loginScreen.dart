import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:letter/widgets/loader.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget { 
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          
          Center(
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
                              'Ingresa con Google',
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
                    onPressed: () {
                      setState(() => loading = true);
                      Provider.of<User>(context, listen: false).login();
                    },
                  ),

                ],
              ),
            ),
          ),

          Loader(loading)

        ],
      ),
    );
  }
}