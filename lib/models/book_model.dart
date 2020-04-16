import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:letter/models/user_model.dart';
import 'package:letter/screens/live_login_screen.dart';
import 'package:letter/screens/subs_step_two_screen.dart';
import 'package:letter/screens/subscribe_screen.dart';
import 'package:letter/widgets/my_dialog.dart';
import 'package:provider/provider.dart';

class BookModel with ChangeNotifier {
  List<dynamic> popularBooks = [];
  Firestore db = Firestore.instance;
  StreamSubscription<QuerySnapshot> streamPopularBooks;
  
  // ---------------------- SEARCH SCREEN ----------------------
  
  bool searching = false, noResults = false, showHelps = true;
  List<dynamic> booksSearched;
  String searchText = '';
  TextEditingController searchController = TextEditingController();
  Map<String, dynamic> helps;
  int cantHelps = 0;
  EdgeInsetsGeometry padding = EdgeInsets.all(0);
  BorderRadiusGeometry borderRadius;

  // ---------------------- SEARCH SCREEN ----------------------

  // ----------------------- RENT BUTTON -----------------------

  bool loadRentButton = false;
  
  // ----------------------- RENT BUTTON -----------------------

  void loadPopularBooks() {
    streamPopularBooks = db.collection('popular_books').orderBy('index').snapshots().listen((snapshot){
      snapshot.documents.forEach((document){
        Map<String, dynamic> book = {
          'title': document.data['title'],
          'author': document.data['author'],
          'image': document.data['image'],
          'url': document.data['url'],
          'review': document.data['review'],
          'details': document.data['details'],
        };
        popularBooks.add(book);
      });
      notifyListeners();
    });
  }

  void cancelStreamPopularBooks(){
    if(streamPopularBooks != null) streamPopularBooks.cancel();
  }

  List<dynamic> getPopularBooks() => popularBooks;

  // ---------------------- SEARCH SCREEN ----------------------

  void hideKeyboard(BuildContext context){
    // Oculto el teclado
    FocusScope.of(context).requestFocus(FocusNode());
    // No muestro las ayudas en el proximo cambio
    showHelps = false;
  }

  void hideHelps(){
    helps = {};
    cantHelps = 0;
    padding = EdgeInsets.all(0);
    borderRadius = BorderRadius.all(Radius.circular(15));
    notifyListeners();
  }

  void search(){
    String search = searchController.text;
    if(search.length > 0){
      searching = true;
      notifyListeners();
      http.post('${globals.baseUrl}/api/v1/books/search', body: {
        'search': search
      }).then((res){
        Map<String, dynamic> data = json.decode(res.body);
        searching = false;
        // No hay resultados
        if(data['books'].length == 0){
          noResults = true;
          booksSearched = null;
        } 
        // Hay resultados
        else booksSearched = data['books'];
        notifyListeners();
      });
    }
  }

  // ---------------------- SEARCH SCREEN ----------------------

  // ----------------------- RENT BUTTON -----------------------

  void rentBook(BuildContext context, String bookUrl, String bookTitle){
    UserModel userModel = Provider.of<UserModel>(context);
    FirebaseUser user = userModel.getUser();
    String subscriptionStatus = userModel.getSubscriptionStatus();
    if(user == null){
      // No inició sesión
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          title: 'Inicia sesión',
          description: 'Inicia sesión para poder alquilar este libro.',
          primaryButtonText: 'INICIAR SESIÓN',
          primaryButtonTextColor: Colors.blueAccent,
          backgroundIconColor1: Colors.blueAccent,
          backgroundIconColor2: Colors.lightBlueAccent,
          icon: Icons.person,
          secondaryButtonText: 'CANCELAR',
          secondaryButtonTextColor: Colors.grey,
          showSecondaryButton: true,
          primaryButtonAction: (){
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LiveLoginScreen(
                showBackIcon: true,
              )),
            ).then((res){
              if(res == 'login-complete') rentBook(context, bookUrl, bookTitle);
            });
          },
          secondaryButtonAction: () => Navigator.of(context).pop(),
        )
      );
    }else if(!userModel.isEmailVerified()){
      // No verificó su cuenta
      loadRentButton = true;
      notifyListeners();
      userModel.reloadUser().then((res){
        loadRentButton = false;
        notifyListeners();
        if(!userModel.isEmailVerified()){
          showDialog(
            context: context,
            builder: (BuildContext context) => MyDialog(
              title: 'Cuenta inactiva',
              description: 'Te enviamos un correo con un enlace para que verifiques y actives tu cuenta.',
              primaryButtonText: 'ENTENDIDO',
              primaryButtonTextColor: Colors.blueAccent,
              backgroundIconColor1: Colors.blueAccent,
              backgroundIconColor2: Colors.lightBlueAccent,
              icon: Icons.person,
              showSecondaryButton: false,
              primaryButtonAction: () => Navigator.of(context).pop(),
            )
          );
        }else rentBook(context, bookUrl, bookTitle);
      });
    }else if(subscriptionStatus == null){
      // Nunca se suscribió
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          title: '¡Ya casi!',
          description: 'Solo falta que te suscribas, te daremos el primer mes gratis :)',
          primaryButtonText: 'SUSCRIBIRME',
          primaryButtonTextColor: Colors.blueAccent,
          backgroundIconColor1: Colors.blueAccent,
          backgroundIconColor2: Colors.lightBlueAccent,
          icon: Icons.tag_faces,
          secondaryButtonText: 'CANCELAR',
          secondaryButtonTextColor: Colors.grey,
          showSecondaryButton: true,
          secondaryButtonAction: () => Navigator.of(context).pop(),
          primaryButtonAction: (){
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubscribeScreen()),
            );
          },
        )
      );
    }else if(subscriptionStatus == 'PENDING'){
      // Tiene que agregar la tarjeta o esperar a que la apruebe
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          title: 'Completa tu suscripción',
          description: 'Termina de agregar los datos de tu tarjeta, no te cobraremos durante el primer mes.\nSi ya realizaste este paso es posible que tengas que esperar unos minutos hasta que activemos tu cuenta.',
          primaryButtonText: 'COMPLETAR SUSCRIPCIÓN', 
          primaryButtonTextColor: Colors.blueAccent,
          backgroundIconColor1: Colors.blueAccent,
          backgroundIconColor2: Colors.lightBlueAccent,
          icon: Icons.tag_faces,
          secondaryButtonText: 'CANCELAR',
          secondaryButtonTextColor: Colors.grey,
          showSecondaryButton: true,
          secondaryButtonAction: () => Navigator.of(context).pop(),
          primaryButtonAction: (){
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubsStepTwoScreen()),
            );
          },
        )
      );
    }else if(subscriptionStatus == 'SUSPENDED'){
      // Su suscripción está pausada
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          title: 'Suscripción inactiva',
          description: 'Tu suscripción está pausada, para que alquiles este libro es necesario que la reactives.',
          primaryButtonText: 'REACTIVAR SUSCRIPCIÓN',
          primaryButtonTextColor: Colors.blueAccent,
          backgroundIconColor1: Colors.blueAccent,
          backgroundIconColor2: Colors.lightBlueAccent,
          icon: Icons.info_outline,
          secondaryButtonText: 'CANCELAR',
          secondaryButtonTextColor: Colors.grey,
          showSecondaryButton: true,
          secondaryButtonAction: () => Navigator.of(context).pop(),
          primaryButtonAction: (){
            Navigator.of(context).pop();
            loadRentButton = true;
            notifyListeners();
            userModel.updateSubscription('ACTIVE').then((res){
              loadRentButton = false;
              notifyListeners();
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
          },
        )
      );
    }else if(subscriptionStatus == 'CANCELLED'){
      // Canceló su suscripción
      showDialog(
        context: context,
        builder: (BuildContext context) => MyDialog(
          title: '¡Ya casi!',
          description: 'Solo falta que te suscribas.',
          primaryButtonText: 'SUSCRIBIRME',
          primaryButtonTextColor: Colors.blueAccent,
          backgroundIconColor1: Colors.blueAccent,
          backgroundIconColor2: Colors.lightBlueAccent,
          icon: Icons.tag_faces,
          secondaryButtonText: 'CANCELAR',
          secondaryButtonTextColor: Colors.grey,
          showSecondaryButton: true,
          secondaryButtonAction: () => Navigator.of(context).pop(),
          primaryButtonAction: (){
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SubsStepTwoScreen(
                noFreeTrial: true,
              )),
            );
          },
        )
      );
    }else if(subscriptionStatus == 'ACTIVE'){
      // Está suscrito 
      String bookRentedLink = userModel.getBookRentedLink();
      String bookRentedStatus = userModel.getBookRentedStatus();
      if(bookRentedLink != null && bookRentedStatus != 'PENDING_RETURN'){
        // Ya alquiló otro libro
        showDialog(
          context: context,
          builder: (BuildContext context) => MyDialog(
            title: 'Uno a la vez',
            description: 'Ya tienes un libro alquilado, solo puedes alquilar de a uno a la vez.',
            primaryButtonText: 'ENTENDIDO',
            primaryButtonTextColor: Colors.blueAccent,
            backgroundIconColor1: Colors.pinkAccent,
            backgroundIconColor2: Colors.redAccent,
            icon: Icons.error_outline,
            showSecondaryButton: false,
            primaryButtonAction: () => Navigator.of(context).pop()
          )
        );          
      }else{
        // Puede alquilar el libro
        showDialog(
          context: context,
          builder: (BuildContext context) => MyDialog(
            title: '¿Confirmar?',
            description: '¿Deseas alquilar este libro?',
            primaryButtonText: 'CONFIRMAR',
            primaryButtonTextColor: Colors.blueAccent,
            backgroundIconColor1: Colors.blueAccent,
            backgroundIconColor2: Colors.lightBlueAccent,
            icon: Icons.help_outline,
            secondaryButtonText: 'CANCELAR',
            secondaryButtonTextColor: Colors.grey,
            showSecondaryButton: true,
            primaryButtonAction: (){
              // Alquilo el libro
              userModel.rentBook(bookUrl);
              // Me envío un email
              String link = '${globals.baseUrl}/api/v1/users/delivery-completed?email=${userModel.getUserEmail()}';
              http.post('${globals.baseUrl}/api/v1/users/send-email', body: {
                'subject': 'Alquilaron un libro :)',
                'email_message': '${userModel.getUserName()} (${userModel.getUserEmail()}) alquiló el libro "$bookTitle" (https://www.cuspide.com$bookUrl).\n\nYa se lo entregué: $link'
              });
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (BuildContext context) => MyDialog(
                  title: '¡Listo!',
                  description: 'Pronto tendrás el libro en tu casa.',
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
  }
  
  // ----------------------- RENT BUTTON -----------------------

}