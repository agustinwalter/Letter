import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:letter/models/user_model.dart';
import 'package:letter/widgets/my_button.dart';
import 'package:letter/widgets/my_dialog.dart';
import 'package:letter/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class LiveLoginScreen extends StatefulWidget {
  final bool showBackIcon;
  const LiveLoginScreen({Key key, this.showBackIcon: false}) : super(key: key);
  @override
  _LiveLoginScreenState createState() => _LiveLoginScreenState();
}

class _LiveLoginScreenState extends State<LiveLoginScreen> {
  String appBarTitle = 'Inicia sesión';
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController pass2Controller = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  bool autovalidate = false;
  bool buttonLoginLoading = false;
  bool buttonRegisLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    userController.dispose();
    pass2Controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(null, 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            gradient: LinearGradient(
              colors: [Colors.lightBlueAccent, Colors.blueAccent],
              begin: Alignment.centerRight,
              end: Alignment(-1.0, -1.0)
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.fromLTRB(20, 35, 20, 18),
          child: Stack(
            children: <Widget>[
              // Icon
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: !widget.showBackIcon ? SizedBox() : 
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    appBarTitle,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: appBarTitle == 'Inicia sesión' ? _buildLogin() : _buildRegister()
          );
        }
      )
    );
  }

  Widget _buildLogin(){
    return Column(
      children: <Widget>[
        Form(
          key: loginFormKey,
          child: Column(
            children: <Widget>[
              // Email
              MyTextField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                controller: emailController,
                autovalidate: autovalidate,
                validator: (value) {
                  if (value.isEmpty) return '    Ingresa tu email\n';
                  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(value)) return '    Ingresa un email válido\n';
                  return null;
                },
              ),
              // Pass
              MyTextField(
                hintText: 'Contraseña',
                prefixIcon: Icons.vpn_key,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                controller: passController,
                autovalidate: autovalidate,
                validator: (value) {
                  if (value.isEmpty) return '    Ingresa una contraseña\n';
                  if (value.toString().length < 6 || value.toString().length > 16) return '    La contraseña debe tener entre 6 y 16 caracteres\n';
                  return null;
                },
              ),
              // Login button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: MyButton(
                  buttonText: 'Iniciar sesión',
                  fontSize: 17,
                  action: () => _login(),
                  loading: buttonLoginLoading,
                ),
              ),
            ],
          )
        ),
        Text('¿No tienes una cuenta?'),
        // Register button
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: MyButton(
            buttonText: 'Regístrate',
            fontSize: 17,
            rightColor: Colors.white,
            leftColor: Colors.white,
            textColor: Colors.blueAccent,
            action: (){
              setState(() {
                passController.clear();
                appBarTitle = 'Regístrate';
              });
            },
          ),
        ),
        Text('o'),
        // Google button
        _googleButton()
      ],
    );
  }

  Widget _buildRegister(){
    return Column(
      children: <Widget>[
        Form(
          key: registerFormKey,
          child: Column(
            children: <Widget>[
              // User
              MyTextField(
                hintText: 'Nombre y apellido',
                prefixIcon: Icons.person,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(30, 30, 30, 0),
                controller: userController,
                autovalidate: autovalidate,
                validator: (value){
                  if (value.isEmpty) return '    Ingresa tu nombre y apellido\n';
                  return null;
                },
              ),
              // Email
              MyTextField(
                hintText: 'Email',
                prefixIcon: Icons.email,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                controller: emailController,
                autovalidate: autovalidate,
                validator: (value) {
                  if (value.isEmpty) return '    Ingresa tu email\n';
                  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(value)) return '    Ingresa un email válido\n';
                  return null;
                },
              ),
              // Pass1
              MyTextField(
                hintText: 'Contraseña',
                prefixIcon: Icons.vpn_key,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                controller: passController,
                autovalidate: autovalidate,
                validator: (value) {
                  if (value.isEmpty) return '    Ingresa una contraseña\n';
                  if (value.toString().length < 6 || value.toString().length > 16) return '    La contraseña debe tener entre 6 y 16 caracteres\n';
                  return null;
                },
              ),
              // Pass2
              MyTextField(
                hintText: 'Repite la contraseña',
                prefixIcon: Icons.vpn_key,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                actionLeft: (){},
                margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
                controller: pass2Controller,
                autovalidate: autovalidate,
                validator: (value) {
                  if (value.isEmpty) return '    Ingresa una contraseña\n';
                  if (value.toString().length < 6 || value.toString().length > 16) return '    La contraseña debe tener entre 6 y 16 caracteres\n';
                  if(value.toString() != passController.text) return '    Las contraseñas no coinciden\n';
                  return null;
                },
              ),
              // Register button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: MyButton(
                  buttonText: 'Registrarme',
                  fontSize: 17,
                  action: () => _register(),
                  loading: buttonRegisLoading,
                ),
              ),
            ]
          )
        ),
        Text('¿Ya tienes una cuenta?'),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: MyButton(
            buttonText: 'Inicia sesión',
            fontSize: 17,
            rightColor: Colors.white,
            leftColor: Colors.white,
            textColor: Colors.blueAccent,
            action: (){
              setState(() {
                passController.clear();
                appBarTitle = 'Inicia sesión';
              });
            },
          ),
        ),
        Text('o'),
        // Google button
        _googleButton()
      ],
    );
  }

  Widget _googleButton(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 30),
      child: GoogleSignInButton(
        darkMode: true,
        text: 'Ingresa con Google',
        onPressed: () async {
          final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          FirebaseAuth.instance.signInWithCredential(
            GoogleAuthProvider.getCredential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            )
          ).then((authResult){
            Provider.of<UserModel>(context).initUser().then((userData){
              if(widget.showBackIcon) Navigator.pop(context, 'login-complete');
            });
          });
        }
      ),
    );
  }

  _login(){
    setState(() {
      if (loginFormKey.currentState.validate()) {
        buttonLoginLoading = true;
        autovalidate = false;
        Provider.of<UserModel>(context).login(emailController.text, passController.text)
        .then((authStatus){
          setState(() => buttonLoginLoading = false);
          if(authStatus == 'ERROR_USER_NOT_FOUND'){
            // No está registrado
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                title: 'No estás registrada/o',
                description: 'Aún no estás registrada/o en Letter. ¡Crea una cuenta ahora!',
                primaryButtonText: 'CREAR CUENTA',
                primaryButtonTextColor: Colors.blueAccent,
                backgroundIconColor1: Colors.pinkAccent,
                backgroundIconColor2: Colors.redAccent,
                icon: Icons.error_outline,
                secondaryButtonText: 'CANCELAR',
                secondaryButtonTextColor: Colors.grey,
                showSecondaryButton: true,
                secondaryButtonAction: () => Navigator.pop(context),
                primaryButtonAction: (){
                  Navigator.pop(context);
                  setState(() {
                    passController.clear();
                    appBarTitle = 'Regístrate';
                  });
                } 
              )
            );
          }else if(authStatus == 'ERROR_WRONG_PASSWORD'){
            // Contraseña incorrecta
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                title: 'Contraseña incorrecta',
                description: 'La contraseña que ingresaste es incorrecta, inténtalo de nuevo.',
                primaryButtonText: 'ENTENDIDO',
                primaryButtonTextColor: Colors.blueAccent,
                backgroundIconColor1: Colors.pinkAccent,
                backgroundIconColor2: Colors.redAccent,
                icon: Icons.error_outline,
                showSecondaryButton: false,
                primaryButtonAction: () => Navigator.pop(context)
              )
            );
          }else if(widget.showBackIcon) Navigator.pop(context, 'login-complete');
        });
      }else autovalidate = true;
    });
  }

  _register(){
    setState(() {
      if (registerFormKey.currentState.validate()) {
        buttonRegisLoading = true;
        autovalidate = false;
        Provider.of<UserModel>(context)
        .register(emailController.text, passController.text, userController.text)
        .then((authStatus){
          setState(() => buttonRegisLoading = false);
          if(authStatus == 'ERROR_WEAK_PASSWORD'){
            // Contraseña débil
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                title: 'Contraseña débil',
                description: 'Tu contraseña es demasiado vulnerable, usa una más compleja',
                primaryButtonText: 'ENTENDIDO',
                primaryButtonTextColor: Colors.blueAccent,
                backgroundIconColor1: Colors.pinkAccent,
                backgroundIconColor2: Colors.redAccent,
                icon: Icons.error_outline,
                showSecondaryButton: false,
                primaryButtonAction: () => Navigator.pop(context)
              )
            );
          }else if(authStatus == 'ERROR_EMAIL_ALREADY_IN_USE'){
            // Email usado
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                title: 'Email no disponible',
                description: 'El email que ingresaste ya está registrado, si eres dueña/o de esa cuenta inicia sesión',
                primaryButtonText: 'INICIAR SESIÓN',
                primaryButtonTextColor: Colors.blueAccent,
                backgroundIconColor1: Colors.pinkAccent,
                backgroundIconColor2: Colors.redAccent,
                icon: Icons.error_outline,
                secondaryButtonText: 'CANCELAR',
                secondaryButtonTextColor: Colors.grey,
                showSecondaryButton: true,
                secondaryButtonAction: () => Navigator.pop(context),
                primaryButtonAction: (){
                  Navigator.pop(context);
                  setState(() {
                    passController.clear();
                    appBarTitle = 'Inicia sesión';
                  });
                } 
              )
            );
          }else if(authStatus == 'EMAIL_VERIFICATION_SENDED' && widget.showBackIcon){
            showDialog(
              context: context,
              builder: (BuildContext context) => MyDialog(
                title: 'Revisa tu email',
                description: 'Te enviamos un correo con un enlace para que verifiques tu cuenta, luego podrás continuar con el alquiler del libro.',
                primaryButtonText: 'ENTENDIDO',
                primaryButtonTextColor: Colors.blueAccent,
                backgroundIconColor1: Colors.blueAccent,
                backgroundIconColor2: Colors.lightBlueAccent,
                icon: Icons.person,
                showSecondaryButton: false,
                primaryButtonAction: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            );
          }
        });
      }else autovalidate = true;
    });
  }

}