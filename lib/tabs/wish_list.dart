import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:letter/screens/add_book_screen.dart';
import 'package:provider/provider.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<User>(
        builder: (context, user, child) {
          List<dynamic> books = user.dataV['wishList'];
          return Container(
            color: books.length == 0 ? CupertinoColors.white : CupertinoColors.extraLightBackgroundGray,
            child: Column(
              children: <Widget>[

                Expanded(child: list(books)),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: CupertinoButton(
                    child: Text('Agregar libro'), 
                    color: CupertinoColors.activeBlue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBookScreen(add: true)),
                      );
                    }
                  ),
                ),
                
              ],
            ),
          );
        }
      )
    );
  }

  Widget list(books){
    if(books.length == 0){
      return emptyMessage();
    }

    return ListView.builder(
      itemCount: books.length + 1,
      padding: EdgeInsets.only(bottom: 5),
      itemBuilder: (BuildContext context, int i) {
        if(i == 0){
          return infoMessage();
        }
        return Card(
          margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Icon(CupertinoIcons.book, color: CupertinoColors.activeBlue,),

                SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text(
                        books[i-1]['title'],
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                        books[i-1]['author'],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),
                      
                    ],
                  )
                ),

                CupertinoButton(
                  padding: EdgeInsets.all(0),
                  minSize: 0,
                  child: Icon(CupertinoIcons.delete, size: 30, color: CupertinoColors.destructiveRed), 
                  onPressed: (){
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: Text("¿Eliminar libro?"),
                        content: Text('¿Deseas quitar "${books[i-1]['title']}" de tu lista de deseos?'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Cancelar"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            child: Text('Eliminar', style: TextStyle(color: CupertinoColors.destructiveRed),),
                            onPressed: () {
                              Navigator.pop(context);
                              Provider.of<User>(context, listen: false).removeBookFromWishList({
                                'title': books[i-1]['title'],
                                'author': books[i-1]['author']
                              });
                            },
                          )
                        ],
                      )
                    );
                  }
                )
                
              ]
            )
          )
        );
      }
    );
  }

   Widget infoMessage(){
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [

              FractionallySizedBox(
                widthFactor: .7,
                child: Image(image: AssetImage('assets/img/wish.png')),
              ),
              
              Text(
                'Libros que quieres leer',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w300
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Agrega aquí los libros que deseas leer y te avisaremos cuando alguien quiera prestártelos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget emptyMessage(){
    return Container(
      color: CupertinoColors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              FractionallySizedBox(
                widthFactor: .8,
                child: Image(image: AssetImage('assets/img/box.png')),
              ),

              Text(
                'Tu lista de deseos está vacia :(',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w300
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 60),
                child: Text(
                  'Agrega aquí los libros que deseas leer y te avisaremos cuando alguien quiera prestártelos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}