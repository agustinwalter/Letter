import 'package:letter/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:letter/models/book_model.dart';
import 'package:letter/models/user_model.dart';
import 'package:provider/provider.dart';
import 'my_button.dart';
import 'my_dialog.dart';

class RentButton extends StatefulWidget {
  final String url, title;
  final double fontSize;
  final bool isGreen;
  const RentButton({Key key, this.url, this.title, this.fontSize: 16, this.isGreen: false}) : super(key: key);
  @override
  _RentButtonState createState() => _RentButtonState();
}

class _RentButtonState extends State<RentButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookModel>(
      builder: (context, bookModel, child) {
        UserModel user = Provider.of<UserModel>(context);
        String bookRentedLink = user.getBookRentedLink();
        String bookRentedStatus = user.getBookRentedStatus();

        if(bookRentedLink == widget.url && bookRentedStatus == 'PENDING_APPROVAL'){
          // Alquiló este libro pero todavía no se lo dí
          return MyButton(
            buttonText: 'Cancelar alquiler',
            fontSize: widget.fontSize,
            leftColor: Colors.pinkAccent,
            rightColor: Colors.redAccent,
            action: () => _cancelRentButton(user, widget.title, widget.url),
          );
        }else if(bookRentedLink == widget.url && bookRentedStatus == 'PENDING_RETURN'){
          // Devolvió este libro pero todavía no lo fuí a buscar
          return MyButton(
            buttonText: 'Cancelar devolución',
            fontSize: widget.fontSize,
            leftColor: Colors.pinkAccent,
            rightColor: Colors.redAccent,
            action: () => _cancelReturnButton(user, widget.title, widget.url),
          );
        }else if(bookRentedLink == widget.url && bookRentedStatus == 'RENTED'){
          // Tiene este libro en sus manos
          if(widget.isGreen){
            return MyButton(
              buttonText: 'Devolver',
              fontSize: widget.fontSize,
              leftColor: Colors.limeAccent,
              rightColor: Colors.limeAccent,
              textColor: Colors.black87,
              action: () => _returnBookButton(user, widget.title, widget.url),
            );
          }
          return MyButton(
            buttonText: 'Devolver',
            fontSize: widget.fontSize,
            action: () => _returnBookButton(user, widget.title, widget.url),
          );
        }

        // No alquiló este libro
        if(widget.isGreen){
          return MyButton(
            buttonText: 'Alquilar',
            fontSize: widget.fontSize,
            loading: bookModel.loadRentButton,
            leftColor: Colors.limeAccent,
            rightColor: Colors.limeAccent,
            textColor: Colors.black87,
            action: () => bookModel.rentBook(context, widget.url, widget.title),
          );
        }
        return MyButton(
          buttonText: 'Alquilar',
          fontSize: widget.fontSize,
          loading: bookModel.loadRentButton,
          action: () => bookModel.rentBook(context, widget.url, widget.title),
        );

      }
    );
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