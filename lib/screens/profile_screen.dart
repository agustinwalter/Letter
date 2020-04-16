import 'dart:convert';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user_model.dart';
import 'package:letter/screens/live_login_screen.dart';
import 'package:letter/screens/subs_step_two_screen.dart';
import 'package:letter/screens/subscribe_screen.dart';
import 'package:letter/widgets/my_button.dart';
import 'package:letter/widgets/my_card.dart';
import 'package:letter/widgets/my_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_address_screen.dart';
import 'package:letter/globals.dart' as globals;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username, subsMessage = '', subsButtonText = '', addressMessage = '', addressButtonText = '';
  Color subsLeftColor, subsRightColor;
  Map<String, dynamic> bookInfo = {
    'image': '',
    'title': '',
    'author': ''
  };
  bool buttonSubsLoading = false;
  bool buttonEmailLoading = false;
  bool buttonWspLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        username = user.getUserName();
        if(username == '') return LiveLoginScreen();
        else return _buildProfile();
      }
    );
  }

  Widget _buildProfile(){
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            // AppBar
            FractionallySizedBox(
              widthFactor: 1,
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
                padding: EdgeInsets.fromLTRB(30, 40, 30, 20),
                child: Text(
                  'Hola, $username',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                )
              )
            ),

            // Check email card
            _chechEmailCard(),

            // Book rented card
            _bookRentedCard(),

            // Subscription card
            _subscriptionCard(),

            // Address card
            _addressCard(),
  
            // Contact card
            MyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title card
                  Text(
                    'Contacto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  // Message
                  Text('Estamos para ayudarte, envíanos un mensaje por cualquiera de los siguientes medios:',),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      MyButton(
                        buttonText: 'WhatsApp',
                        fontSize: 16,
                        loading: buttonWspLoading,
                        action: () async {
                          const url = 'https://wa.me/543412179096';
                          if (await canLaunch(url) != null) {
                            setState(() => buttonWspLoading = true);
                            await launch(url);
                            setState(() => buttonWspLoading = false);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                      MyButton(
                        buttonText: ' Email ',
                        fontSize: 16,
                        loading: buttonEmailLoading,
                        action: () async {
                          final Email email = Email(
                            body: '',
                            subject: 'Contacto Letter',
                            recipients: ['letterlibros@gmail.com']
                          );
                          setState(() => buttonEmailLoading = true);
                          await FlutterEmailSender.send(email);
                          setState(() => buttonEmailLoading = false);
                        },
                      ),
                    ],
                  ),
                ],
              )
            ),

            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: FlatButton(
                  child: Text('CERRAR SESIÓN'),
                  textColor: Colors.pinkAccent,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => MyDialog(
                        title: 'Cerrar sesión',
                        description: '¿Deseas cerrar la sesión de tu cuenta?',
                        primaryButtonText: 'CERRAR SESIÓN',
                        primaryButtonTextColor: Colors.pinkAccent,
                        backgroundIconColor1: Colors.pinkAccent,
                        backgroundIconColor2: Colors.redAccent,
                        icon: Icons.exit_to_app,
                        secondaryButtonText: 'CANCELAR',
                        secondaryButtonTextColor: Colors.grey,
                        showSecondaryButton: true,
                        primaryButtonAction: () {
                          Provider.of<UserModel>(context).closeSession();
                          Navigator.of(context).pop();
                        },
                        secondaryButtonAction: () => Navigator.of(context).pop(),
                      )
                    );
                  }
                ),
              ),
            ),

          ],
        );
      }
    );
  }

  Widget _bookRentedCard(){
    return Consumer<UserModel>(
      builder: (context, user, child) {
        String bookRentedLink = user.getBookRentedLink();
        String bookRentedStatus = user.getBookRentedStatus();
        String buttonText, message;
        Color leftColor, rightColor;
        if(bookRentedLink != null){
          http.post('${globals.baseUrl}/api/v1/books/get_simple_book_info', body: {
            'book': bookRentedLink
          }).then((res){
            Map<String, dynamic> data = json.decode(res.body);
            setState(() => bookInfo = data);
          });
        }
        if(bookRentedLink != null && bookRentedStatus == 'PENDING_APPROVAL'){
          // El libro está siendo preparado para entregar
          buttonText = 'Cancelar alquiler';
          leftColor = Colors.pinkAccent;
          rightColor = Colors.redAccent;
          message = 'Estamos preparando el libro, pronto te lo llevaremos a tu casa.';
        }else if(bookRentedLink != null && bookRentedStatus == 'RENTED'){
          // El libro ya está en manos del usuario
          buttonText = 'Devolver libro';
          leftColor = Colors.blueAccent;
          rightColor = Colors.lightBlueAccent;
          message = '';
        }else if(bookRentedLink != null && bookRentedStatus == 'PENDING_RETURN'){
          // El libro está por ser devuelto
          buttonText = 'Cancelar devolución';
          leftColor = Colors.pinkAccent;
          rightColor = Colors.redAccent;
          message = 'Pronto pasaremos a buscar el libro por tu casa.';
        }else{
          // No alquiló ningún libro
          return SizedBox(height: 20);
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: MyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Card title
                Text(
                  'Libro alquilado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Book image
                    Container(
                      height: 120,
                      color: Color(0X00000000),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          bookInfo['image'],
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      )
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Book title
                          Text(
                            bookInfo['title'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          // Book author
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              bookInfo['author'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Message
                          Text(message),
                          // Button
                          MyButton(
                            buttonText: buttonText,
                            fontSize: 14,
                            leftColor: leftColor,
                            rightColor: rightColor,
                            action: (){
                              if(buttonText == 'Cancelar alquiler') _cancelRentButton(user, bookInfo['title'], bookRentedLink);
                              else if(buttonText == 'Devolver libro') _returnBookButton(user, bookInfo['title'], bookRentedLink);
                              else _cancelReturnButton(user, bookInfo['title'], bookRentedLink);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )
          ),
        );
      }
    );
  }

  Widget _subscriptionCard(){
    return Consumer<UserModel>(
      builder: (context, user, child) {
        String subsStatus = user.getSubscriptionStatus();
        // bool offerFreeTrial = user.offerFreeTrial();
        if(subsStatus == 'ACTIVE'){
          subsMessage = '¡Tu suscripción está activa, puedes leer todo lo que quieras!';
          subsButtonText = 'Pausar suscripción';
          subsLeftColor = Colors.pinkAccent;
          subsRightColor = Colors.redAccent;
        }else if(subsStatus == 'SUSPENDED'){
          subsMessage = 'Tu suscripción está pausada por lo que no te cobraremos más. Puedes reactivarla cuando quieras :)';
          subsButtonText = 'Reactivar suscripción';
          subsLeftColor = Colors.blueAccent;
          subsRightColor = Colors.lightBlueAccent;
        }else if(subsStatus == 'PENDING'){
          subsMessage = 'Continúa con el proceso de suscripción para poder leer todo lo que quieras.';
          subsButtonText = 'Continuar suscripción';
          subsLeftColor = Colors.blueAccent;
          subsRightColor = Colors.lightBlueAccent;
        }else{
          subsMessage = 'No tienes una suscripcion activa. Suscríbete para empezar a leer lo que quieras :)';
          subsButtonText = 'Suscribirme';
          subsLeftColor = Colors.blueAccent;
          subsRightColor = Colors.lightBlueAccent;
        }
        return MyCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Title card
              Text(
                'Suscripción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              // Message
              Text(subsMessage),
              // Button
              Container(
                child: subsMessage == '' ? Container() :
                MyButton(
                  buttonText: subsButtonText,
                  fontSize: 14,
                  action: (){
                    if(subsButtonText == 'Suscribirme') _goToSubscribe(user);
                    else if(subsButtonText == 'Reactivar suscripción') _goToReactiveSubscription(user);
                    else if(subsButtonText == 'Continuar suscripción') _goToContinueSubscription(user);
                    else _goToSuspendSubscription(user);
                  },
                  leftColor: subsLeftColor,
                  rightColor: subsRightColor,
                  loading: buttonSubsLoading,
                ),
              )
            ],
          )
        );
      }
    );
  }

  Widget _addressCard(){
    return Consumer<UserModel>(
      builder: (context, user, child) {
        Map<dynamic, dynamic> address = user.getAddress();
        if(address == null){
          return SizedBox(height: 30);
        }else{
          addressMessage = '${address['street']} ${address['number']}, ${address['city']} ${address['postal_code']}, ${address['province']}';
          addressButtonText = 'Modificar dirección';
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: MyCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title card
                Text(
                  'Dirección de envío',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Message
                Text(addressMessage),
                // Button
                Container(
                  child: addressButtonText == '' ? Container() :
                  MyButton(
                    buttonText: addressButtonText,
                    fontSize: 16,
                    action: (){
                      if(address == null){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddAddressScreen()),
                        );
                      }else{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddAddressScreen(
                            appBarTitle: 'Modificar dirección'
                          )),
                        );
                      }
                    },
                  ),
                )
              ],
            )
          ),
        );
      }
    );
  }

  Widget _chechEmailCard(){
    return Consumer<UserModel>(
      builder: (context, user, child) {
        if(!user.isEmailVerified()){
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: MyCard(
              color: Colors.yellow[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title card
                  Text(
                    'Revisa tu email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                  SizedBox(height: 5),
                  // Message
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.deepOrange,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Te enviamos un correo a '),
                        TextSpan(text: '${user.getUserEmail()}', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' con un enlace para que verifiques tu cuenta.'),
                      ]
                    )
                  )
                ]
              )
            )
          );
        }
        return SizedBox();
      }
    );
  }

  _goToContinueSubscription(UserModel user){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubsStepTwoScreen()),
    );
  }

  _goToSubscribe(UserModel user){
    if(!user.isEmailVerified()){
      // No verificó su cuenta
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          title: 'Cuenta inactiva',
          description: 'Te enviamos un correo con un enlace para que verifiques y actives tu cuenta. Luego podrás suscribirte.',
          primaryButtonText: 'ENTENDIDO',
          primaryButtonTextColor: Colors.blueAccent,
          backgroundIconColor1: Colors.blueAccent,
          backgroundIconColor2: Colors.lightBlueAccent,
          icon: Icons.person,
          showSecondaryButton: false,
          primaryButtonAction: () => Navigator.of(context).pop(),
        )
      );
    }else{
      // Se puede suscribir
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubscribeScreen()),
      );
    }
  }

  _goToSuspendSubscription(UserModel user){
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        title: '¿Quieres tomarte un descanso?',
        description: 'Puedes pausar la suscripción Y no te cobraremos nada hasta que la reactives.',
        primaryButtonText: 'PAUSAR SUSCRIPCIÓN',
        primaryButtonTextColor: Colors.blueAccent,
        backgroundIconColor1: Colors.blueAccent,
        backgroundIconColor2: Colors.lightBlueAccent,
        icon: Icons.info_outline,
        showSecondaryButton: false,
        primaryButtonAction: (){
          user.updateSubscription('SUSPENDED').then((res){
            Navigator.pop(context);
            if(res == 'SUSPENDED'){
              showDialog(
                context: context,
                builder: (BuildContext context) => MyDialog(
                  title: '¡Listo!',
                  description: 'Pausaste la suscripción por lo que no te cobraremos hasta que la reactives.',
                  primaryButtonText: 'ENTENDIDO',
                  primaryButtonTextColor: Colors.blueAccent,
                  backgroundIconColor1: Colors.lime,
                  backgroundIconColor2: Colors.green,
                  icon: Icons.done_outline,
                  showSecondaryButton: false,
                  primaryButtonAction: () => Navigator.of(context).pop(),
                )
              );
            }
          });
        }
      )
    );
  }

  _goToReactiveSubscription(UserModel user){
    setState(() => buttonSubsLoading = true);
    user.updateSubscription('ACTIVE').then((res){
      setState(() => buttonSubsLoading = false);
      if(res == 'ACTIVE'){
        showDialog(
          context: context,
          builder: (BuildContext context) => MyDialog(
            title: '¡Listo!',
            description: 'Reactivaste la suscripción, puedes volver a leer todo lo que quieras.',
            primaryButtonText: 'ENTENDIDO',
            primaryButtonTextColor: Colors.blueAccent,
            backgroundIconColor1: Colors.lime,
            backgroundIconColor2: Colors.green,
            icon: Icons.done_outline,
            showSecondaryButton: false,
            primaryButtonAction: () => Navigator.of(context).pop(),
          )
        );
      }
    });
  }

  _cancelRentButton(UserModel user, String title, String url){
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        title: '¿Confirmar?',
        description: '¿Deseas cancelar el alquiler de este libro?',
        primaryButtonText: 'SI, CANCELAR ALQUILER',
        primaryButtonTextColor: Colors.pinkAccent,
        backgroundIconColor1: Colors.pinkAccent,
        backgroundIconColor2: Colors.redAccent,
        icon: Icons.error_outline,
        secondaryButtonText: 'NO, SALIR',
        secondaryButtonTextColor: Colors.grey,
        showSecondaryButton: true,
        primaryButtonAction: (){
          user.cancelRentBook();
          http.post('${globals.baseUrl}/api/v1/users/send-email', body: {
            'subject': 'Cancelaron el alquiler de un libro :(',
            'email_message': '${user.getUserName()} (${user.getUserEmail()}) canceló el alquiler del libro "$title" (https://www.cuspide.com$url).'
          });
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              title: '¡Listo!',
              description: 'Cancelaste el alquiler de este libro.',
              primaryButtonText: 'ENTENDIDO',
              primaryButtonTextColor: Colors.blueAccent,
              backgroundIconColor1: Colors.lime,
              backgroundIconColor2: Colors.green,
              icon: Icons.done_outline,
              showSecondaryButton: false,
              primaryButtonAction: () => Navigator.of(context).pop(),
            )
          );
        },
        secondaryButtonAction: () => Navigator.of(context).pop(),
      )
    );
  }

  _returnBookButton(UserModel user, String title, String url){
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        title: '¿Confirmar?',
        description: '¿Deseas devolver este libro?',
        primaryButtonText: 'CONFIRMAR',
        primaryButtonTextColor: Colors.blueAccent,
        backgroundIconColor1: Colors.blueAccent,
        backgroundIconColor2: Colors.lightBlueAccent,
        icon: Icons.help_outline,
        secondaryButtonText: 'CANCELAR',
        secondaryButtonTextColor: Colors.grey,
        showSecondaryButton: true,
        primaryButtonAction: (){
          // Actualizo el estado del libro
          user.updateBookStatus('PENDING_RETURN');
          // Me envío un email
          String link = '${globals.baseUrl}/api/v1/users/return-completed?email=${user.getUserEmail()}';
          http.post('${globals.baseUrl}/api/v1/users/send-email', body: {
            'subject': 'Devolvieron un libro :)',
            'email_message': '${user.getUserName()} (${user.getUserEmail()}) quiere devolver el libro "$title" (https://www.cuspide.com$url).\n\nYa lo devolvió: $link'
          });
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              title: '¡Listo!',
              description: 'Pronto pasaremos a buscar el libro por tu casa.',
              primaryButtonText: 'ENTENDIDO',
              primaryButtonTextColor: Colors.blueAccent,
              backgroundIconColor1: Colors.lime,
              backgroundIconColor2: Colors.green,
              icon: Icons.done_outline,
              showSecondaryButton: false,
              primaryButtonAction: () => Navigator.of(context).pop(),
            )
          );
        },
        secondaryButtonAction: () => Navigator.of(context).pop()
      )
    );
  }

  _cancelReturnButton(UserModel user, String title, String url){
    showDialog(
      context: context,
      builder: (BuildContext context) => MyDialog(
        title: '¿Confirmar?',
        description: '¿Deseas cancelar la devolución de este libro?',
        primaryButtonText: 'SI, CANCELAR DEVOLUCIóN',
        primaryButtonTextColor: Colors.pinkAccent,
        backgroundIconColor1: Colors.pinkAccent,
        backgroundIconColor2: Colors.redAccent,
        icon: Icons.error_outline,
        secondaryButtonText: 'NO, SALIR',
        secondaryButtonTextColor: Colors.grey,
        showSecondaryButton: true,
        primaryButtonAction: (){
          user.updateBookStatus('RENTED');
          http.post('${globals.baseUrl}/api/v1/users/send-email', body: {
            'subject': 'Cancelaron la devolución de un libro :|',
            'email_message': '${user.getUserName()} (${user.getUserEmail()}) canceló la devolución del libro "$title" (https://www.cuspide.com$url).\n\nNo tenés que ir a su casa a buscarlo.'
          });
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              title: '¡Listo!',
              description: 'Cancelaste la devolución de este libro, no iremos a tu casa a buscarlo.',
              primaryButtonText: 'ENTENDIDO',
              primaryButtonTextColor: Colors.blueAccent,
              backgroundIconColor1: Colors.lime,
              backgroundIconColor2: Colors.green,
              icon: Icons.done_outline,
              showSecondaryButton: false,
              primaryButtonAction: () => Navigator.of(context).pop(),
            )
          );
        },
        secondaryButtonAction: () => Navigator.of(context).pop(),
      )
    );
  }

}