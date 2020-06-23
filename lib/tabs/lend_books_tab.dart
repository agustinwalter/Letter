import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:letter/screens/lend_book_details_screen.dart';
import 'package:letter/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class LendBooksTab extends StatefulWidget {
  @override
  _LendBooksTabState createState() => _LendBooksTabState();
}

class _LendBooksTabState extends State<LendBooksTab> {
  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getBooksToLend();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      child: Consumer<User>(
        builder: (context, user, child) {
          if(user.booksToLend == null) return Loader(true);
          if(user.booksToLend.length == 0) return emptyMessage();
          user.booksToLend.sort((a, b) => a['distance'].compareTo(b['distance']));

          return ListView.builder(
            itemCount: user.booksToLend.length + 1,
            padding: EdgeInsets.only(bottom: 5),
            itemBuilder: (BuildContext context, int i) {
              if(i == 0) return infoMessage();
              return GestureDetector(
                child: Card(
                  margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                                user.booksToLend[i-1]['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4,),
                              Text(
                                user.booksToLend[i-1]['author'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Lato',
                                ),
                              ),
                              
                            ],
                          )
                        ),

                      ],
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(
                    CupertinoPageRoute(builder: (context){
                      return LendBookDetails(bookName: user.booksToLend[i-1]['title']);
                    })
                  );
                },
              );
            }
          );
        }
      )
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
                child: Image(image: AssetImage('assets/img/people.png')),
              ),
              
              Text(
                'Personas cercanas a ti quieren leer estos libros',
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
                  '¡Si tienes alguno, puedes prestárselo y sumar puntos!',
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
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image(image: AssetImage('assets/img/empty.png')),
              ),

              Text(
                'Nada por aquí',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.w300
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 60),
                child: Text(
                  'Por el momento, no hay personas cercanas a ti que quieran leer libros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),

              CupertinoButton(
                color: CupertinoColors.activeBlue,
                child: Text('Invitar amig@s'), 
                onPressed: () {
                  Share.share(
                    '¡Ey! Descarga esta aplicación para prestarnos libros: https://play.google.com/store/apps/details?id=com.application.letter', 
                    subject: 'Una aplicación para prestarnos libros'
                  );
                }
              )

            ],
          ),
        ),
      ),
    );
  }

}