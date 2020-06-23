import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:provider/provider.dart';

class AddBookScreen extends StatefulWidget {
  final bool add;
  const AddBookScreen({Key key, this.add: false}) : super(key: key);
  @override
  _AddBookScreenState createState() => _AddBookScreenState(add);
}

class _AddBookScreenState extends State<AddBookScreen> {
  String title = '', author = '';
  final bool add;

  _AddBookScreenState(this.add);

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
                      msg: "Escribe el título del libro",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16
                    );
                  }else if(author == ''){
                    Fluttertoast.showToast(
                      msg: "Escribe el autor del libro",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16
                    );
                  }else{
                    if(add){
                      Provider.of<User>(context, listen: false).addBookToWishList({
                        'title': titleCase(title),
                        'author': titleCase(author)
                      });
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pop(context, {
                      'title': titleCase(title),
                      'author': titleCase(author)
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

  String titleCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    List<String> words = text.split(' ');
    var capitalized = words.map((word) {
      String first = word.substring(0, 1).toUpperCase();
      String rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

}
