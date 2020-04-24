import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  String title = '', author = '';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              '¿Cuál es el título del libro?',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w300
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: CupertinoTextField(
                keyboardType: TextInputType.text,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                placeholder: 'Ej. Cien años de soledad',
                autofocus: true,
                onChanged: (text) => title = text,
              ),
            ),

            Text(
              '¿Quién es el autor?',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w300
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: CupertinoTextField(
                keyboardType: TextInputType.text,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                placeholder: 'Ej. Gabriel García Márquez',
                onChanged: (text) => author = text,
              ),
            ),

            Center(
              child: CupertinoButton(
                color: Color(0xff007aff),
                child: Text('Agregar libro'), 
                onPressed: () {
                  if(title == ''){
                    Fluttertoast.showToast(
                      msg: "Escribí el título del libro",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16
                    );
                  }else if(author == ''){
                    Fluttertoast.showToast(
                      msg: "Escribí el autor del libro",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16
                    );
                  }else{
                    FocusScope.of(context).requestFocus(new FocusNode());
                    Navigator.pop(context, {
                      'title': title,
                      'author': author
                    });
                  }
                }
              ),
            ),

            Center(
              child: CupertinoButton(
                child: Text('Volver'), 
                onPressed: () => Navigator.pop(context)
              ),
            ),

          ]
        ),
      )
    );
  }
}
