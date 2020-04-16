import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; 
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(Letter());
}

class Letter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: LetterHome()
    );
  }
}

class LetterHome extends StatefulWidget {
  @override
  _LetterHomeState createState() => _LetterHomeState();
}

class _LetterHomeState extends State<LetterHome> {
  String email = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/img/developer.png')),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Text('Estamos desarrollando una nueva versión de Letter.'),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: Text(
                    'Dejanos tu email y te avisaremos cuando esté disponible. No te enviaremos publicidad.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),

                CupertinoTextField(
                  padding: EdgeInsets.all(10),
                  keyboardType: TextInputType.emailAddress,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  placeholder: 'Ingresá tu email aquí',
                  onChanged: (texto) => email = texto,
                ),

                SizedBox(height: 30),

                CupertinoButton(
                  color: Color(0xff007aff),
                  child: loading ? CupertinoActivityIndicator() : Text('Enviar'), 
                  onPressed: (){
                    if(email != ''){
                      // Me envío un email
                      setState(() => loading = true);
                      http.get('https://us-central1-letter-bfbab.cloudfunctions.net/sendNotificationEmail?email=$email')
                      .then((value) {
                        setState(() => loading = false);
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) => CupertinoAlertDialog(
                            title: Text('¡Recibimos tu email!'),
                            content: Text('Te enviaremos un correo cuando la app vuelva a estar disponible.'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                child: Text('Entendido'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          )
                        );
                      });
                    }
                  }
                )

              ],
            ),
          ),
        )
      )
    );
  }
}