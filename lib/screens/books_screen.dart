import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/screens/book_description_screen.dart';
import 'package:letter/widgets/my_button.dart';
import 'package:letter/widgets/rent_button.dart';
import 'package:letter/widgets/simple_description.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text('Letter', style: TextStyle(color: Colors.black54, fontSize: 22)),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.fromLTRB(8, 12, 0, 13),
          child: Image.asset('assets/img/icon.png'),
        ),
        titleSpacing: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('categories').orderBy('index').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return _infoMessage('Algo salió mal, inténtalo de nuevo más tarde.');
          if (!snapshot.hasData) return SizedBox();
          if (snapshot.data.documents.length == 0) return _infoMessage('No se encontró ningún libro');
          int cantCategories = snapshot.data.documents.length;
          return ListView.builder(
            itemCount: cantCategories + 1,
            padding: EdgeInsets.symmetric(vertical: 20),
            itemBuilder: (context, index){
              if(index == 0){
                return _firstBook();
              }else{
                String categoryName = snapshot.data.documents[index - 1]['category_name'];
                return _categories(categoryName, index - 1);
              }
            }
          );
        }
      ),
    );
  }

  Widget _infoMessage(String message){
    return Center(
      child: Container(
        height: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.info_outline, size: 30, color: Colors.black54,),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Text(message),
            )
          ],
        ),
      ),
    );
  }

  Widget _firstBook(){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('books').where('category_id', isEqualTo: '0')
      .where('index', isEqualTo: '0').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Auxiliar para evitar error de desplazamiento
        if (!snapshot.hasData){
          return Column(
            children: <Widget>[
              SizedBox(height: 190),
              MyButton(
                buttonText: 'Cargando',
                rightColor: Colors.white,
                leftColor: Colors.white,
                textColor: Colors.blueAccent,
                fontSize: 16,
                action: (){},
              ),
            ],
          );
        } 
        
        DocumentSnapshot book = snapshot.data.documents[0];
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(snapshot.data.documents[0]['image'], height: 190)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MyButton(
                    buttonText: 'Detalles',
                    fontSize: 16,
                    rightColor: Colors.white,
                    leftColor: Colors.white,
                    textColor: Colors.blueAccent,
                    action: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookDescriptionScreen(
                          book: book,
                          title: book['title'],
                          image: book['image'],
                          url: book['url'],
                        )),
                      );
                    },
                  ),
                  SizedBox(width: 15),
                  RentButton(
                    url: book['description_url'],
                    title: book['title'],
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }

  Widget _categories(String categoryName, int categoryId){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('books').where('category_id', isEqualTo: '$categoryId').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return _infoMessage('Ocurrió un problema en esta categoría.');
        // Auxiliar para evitar error de desplazamiento
        if (!snapshot.hasData){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 10),
                child: Text(
                  ' ',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              SizedBox(height: 145)
            ],
          );
        }
        if (snapshot.data.documents.length == 0) return _infoMessage('No se encontraron libros para esta categoría.');

        int cantBooks = snapshot.data.documents.length;
        List<DocumentSnapshot> books = snapshot.data.documents;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 0, 10),
                child: Text(
                  categoryName,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: 145,
                child: ListView.builder(
                  itemCount: cantBooks,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index){
                    if(categoryId == 0 && index == 0) return SizedBox();
                    // Ordeno los libros
                    DocumentSnapshot book =  books.elementAt(
                      books.indexWhere((book) => book.data['index'] == '$index')
                    );
                    // Oculto los infantiles
                    if(book['action'] == 'Ocultar') return SizedBox();
                    return _book(book);
                  }
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _book(DocumentSnapshot book){
    return GestureDetector(
      child: Container(
        height: 145,
        width: 100,
        margin: EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: book['image'],
            errorWidget: (context, url, error) {
              return Container(
                height: 145,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image, color: Colors.black54,),
                    SizedBox(height: 5,),
                    Text('Imagen no disponible', style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context) => SimpleDescription(
            book: book.data,
          )
        );
      },
    );
  }

}