import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/screens/add_book_screen.dart';

class WishList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: CupertinoColors.extraLightBackgroundGray,
        child: Column(
          children: <Widget>[

            Expanded(
              child: ListView.builder(
                itemCount: 10,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                itemBuilder: (BuildContext context, int i) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Padding(
                      // padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
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
                                  'Título del libro $i',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  'Autor del libro $i',
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
                            onPressed: (){}
                          )
                          
                        ]
                      )
                    )
                  );
                }
              )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: CupertinoButton(
                child: Text('Agregar libro'), 
                color: CupertinoColors.activeBlue,
                onPressed: () async {
                  final newBook = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddBookScreen()),
                  );
                  // if(newBook != null) setState(() => addedBooks.add(newBook));
                }
              ),
            ),
            
          ],
        ),
      )
    );
  }
}