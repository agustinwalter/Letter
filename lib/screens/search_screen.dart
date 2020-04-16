import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:letter/models/book_model.dart';
import 'package:letter/widgets/my_text_field.dart';
import 'package:letter/widgets/simple_description.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double screenWidth; 

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: SearchBar(),
      body: _content(),
    );
  }

  Widget _content(){
    return Consumer<BookModel>(
      builder: (context, book, child) {
        // Si està buscando libros muestro el icono de carga
        if(book.searching){ return Center( child: CircularProgressIndicator(strokeWidth: 1.5) ); }
        // Si encontró libros, los muestro
        else if(book.booksSearched != null){ return _books(book.booksSearched); }
        else if(book.noResults) return _noResults();
        return _recents();
      }
    );
  }
  
  Widget _noResults(){
    return Center(
      child: Container(
        height: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.info_outline, size: 30, color: Colors.black54,),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                'No encontramos ningún libro que coincida con tu búsqueda, prueba usar otras palabras.', 
                textAlign: TextAlign.center
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _books(List<dynamic> books){
    int cantRows = 1;
    if(books.length > 3) cantRows = (books.length / 3).ceil();

    return ListView.builder(
      itemCount: cantRows,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      itemBuilder: (context, index){
        int i0 = index * 3;
        int i1 = (index * 3) + 1;
        int i2 = (index * 3) + 2;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _book(books[i0]),
            Container( child: i1 < books.length ? _book(books[i1]) : SizedBox(width: screenWidth * .27) ),
            Container( child: i2 < books.length ? _book(books[i2]) : SizedBox(width: screenWidth * .27) )
          ],
        );
      }
    );
  }

  Widget _book(book){
    return GestureDetector(
      child: Container(
        height: screenWidth * .38,
        width: screenWidth * .27,
        margin: EdgeInsets.only(bottom: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          // child: Image.network(
          //   book['image'],
          //   fit: BoxFit.cover,
          // ),
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
            title: book['title'],
            image: book['image'],
            descriptionUrl: book['description_url'],
          )
        );
      },
    );
  }

  Widget _recents(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 10),
            child: Text(
              'Búsquedas frecuentes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ),

        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('popular_searches')
          .orderBy('count', descending: true).limit(15).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return SizedBox();
            if (!snapshot.hasData) return SizedBox();
            if (snapshot.data.documents.length == 0) return SizedBox();
            int cantSeaches = snapshot.data.documents.length;
            return Expanded(
              child: ListView.builder(
                itemCount: cantSeaches,
                itemBuilder: (context, index){
                  String search = snapshot.data.documents[index].data['search'];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            search, 
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        dense: true,
                        onTap: (){
                          // Busco libros
                          Provider.of<BookModel>(context).hideKeyboard(context);
                          Provider.of<BookModel>(context).searchController.text = search;
                          Provider.of<BookModel>(context).search();
                        },
                      ),
                      Divider(
                        thickness: 0,
                        height: 0,
                      )
                    ],
                  );
                }
              ),
            );
          }
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(600);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 35, 15, 15),
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
      child: SearchField(),
    );
  }    
}

class SearchField extends StatefulWidget {
  @override
  _SearchFieldState createState() => _SearchFieldState();
}
class _SearchFieldState extends State<SearchField> {
  @override
  void initState() {
    super.initState();
    () async {
      await Future.delayed(Duration.zero);

      BookModel book = Provider.of<BookModel>(context);
      book.searchController.addListener((){
        if(book.searchController.text.length > 2){
          if(book.showHelps){
            String terms = book.searchController.text;
            terms = terms.replaceAll(' ', '+');
            http.get('https://www.cuspide.com/handlers/autoComplete.ashx?term=$terms').then((res){
              if(book.searchController.text.length > 2){
                setState(() {
                  // Muestro las ayudas
                  book.helps = json.decode(res.body);
                  if (book.helps.length < 5) book.cantHelps = book.helps.length;
                  else book.cantHelps = 5;
                  if(book.cantHelps > 0){
                    book.padding = EdgeInsets.fromLTRB(8, 0, 8, 8);
                    book.borderRadius = BorderRadius.vertical(top: Radius.circular(15));
                  }else{
                    book.padding = EdgeInsets.all(0);
                    book.borderRadius = BorderRadius.all(Radius.circular(15));
                  } 
                });
              }
            }); 
          }else book.showHelps = true;
        }else{
          // Oculto las ayudas
          book.hideHelps();
        }
        if(book.searchController.text.length == 0){
          setState(() {
            book.searching = false;
            book.noResults = false;
            book.booksSearched = null; 
          });
        }
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookModel>(
      builder: (context, book, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Text field
            MyTextField(
              showSadow: false,
              hintText: 'Busca títulos o autores',
              prefixIcon: Icons.search,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.text,
              margin: EdgeInsets.all(0),
              controller: book.searchController,
              actionLeft: () {
                // Busco libros
                book.hideKeyboard(context);
                book.hideHelps();
                book.search();
              },
              onFieldSubmitted: (String text) {
                // Busco libros
                book.hideKeyboard(context);
                book.hideHelps();
                book.search();
              },
              borderRadius: book.borderRadius
            ),
            // Helps
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: ListView.builder(
                itemCount: book.cantHelps,
                shrinkWrap: true,
                padding: book.padding,
                itemBuilder: (context, index){
                  return GestureDetector(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Divider(height: 0),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              book.helps['$index'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      // Busco libros
                      book.hideKeyboard(context);
                      // Completo el campo de texto
                      book.searchController.text = book.helps['$index'];
                      book.hideHelps();
                      book.search();
                    },
                  );
                }
              )
            )
          ],
        );
      }
    );
  }
}