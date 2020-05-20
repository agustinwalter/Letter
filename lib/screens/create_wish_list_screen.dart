import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:letter/models/user.dart';
import 'package:letter/screens/add_book_screen.dart';
import 'package:letter/widgets/loader.dart';
import 'package:provider/provider.dart';

class CreateWishListScreen extends StatefulWidget {
  @override
  _CreateWishListScreenState createState() => _CreateWishListScreenState();
}

class _CreateWishListScreenState extends State<CreateWishListScreen> {
  List<Map<String, String>> addedBooks = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    int needToAdd = 3 - addedBooks.length;
    final user = Provider.of<User>(context, listen: false);
    
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(image: AssetImage('assets/img/books.png')),
                  ),

                  Text(
                    'Creemos tu lista de deseos',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      'Agrega tres libros que quieras leer',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),

                  Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) => addedBooks.isNotEmpty,
                    widgetBuilder: (BuildContext context) => bookList(addedBooks),
                    fallbackBuilder: (BuildContext context) => SizedBox.shrink(),
                  ),

                  ConditionalSwitch.single<int>(
                    context: context,
                    valueBuilder: (BuildContext context) => needToAdd,
                    caseBuilders: {
                      2: (BuildContext context) => message('Solo te faltan dos libros'),
                      1: (BuildContext context) => message('Solo te falta un libro'),
                    },
                    fallbackBuilder: (BuildContext context) => SizedBox.shrink(),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CupertinoButton(
                      color: Color(0xff007aff),
                      child: needToAdd == 0 ? Text('Continuar') : Text('Agregar libro'), 
                      onPressed: () async {
                        if(needToAdd == 0){
                          setState(() => loading = true);
                          await user.createWishList(addedBooks);
                        }else{
                          final newBook = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddBookScreen()),
                          );
                          if(newBook != null) setState(() => addedBooks.add(newBook));
                        }
                      }
                    ),
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

Widget bookList(List<Map<String, String>> books){
  return Expanded(
    child: ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      itemCount: books.length,
      itemBuilder: (BuildContext context, int i) {
        return bookCard(books[i]['title'], books[i]['author']);
      }
    )
  );
}

Widget message(String text){
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w300
      ),
    ),
  );
}

Widget bookCard(title, author){
  return Card(
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(CupertinoIcons.book),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold
                ),
              ),

              Text(
                author,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),

            ]
          ),
        ],
      ),
    )
  );  
}
