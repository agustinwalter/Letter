import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:letter/screens/book_description_screen.dart';
import 'package:letter/widgets/image_viewer.dart';
import 'package:letter/widgets/my_button.dart';
import 'package:http/http.dart' as http;
import 'package:letter/globals.dart' as globals;
import 'package:letter/widgets/rent_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SimpleDescription extends StatefulWidget {
  final book;
  final String title, image, descriptionUrl;
  const SimpleDescription({Key key, this.book, this.title, this.image, this.descriptionUrl}) : super(key: key);

  @override
  _SimpleDescriptionState createState() => _SimpleDescriptionState(book, title);
}

class _SimpleDescriptionState extends State<SimpleDescription> {
  var book;
  String title;
  _SimpleDescriptionState(this.book, this.title);

  @override
  void initState() {
    super.initState();
    if(title != null){
      // Esto se ejecuta cuando busco un libro en la pantalla de búsqueda
      http.post('${globals.baseUrl}/api/v1/books/get_book_info', body: {
        'book': widget.descriptionUrl
      }).then((res){
        var data = json.decode(res.body);
        setState(() {
          title = null;
          return book = data;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    String bookTitle = title;
    if(bookTitle == null) bookTitle = book['title'];
    String bookImage = widget.image;
    if(bookImage == null) bookImage = book['image'];
    
    return Stack(
      children: <Widget>[
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.navigate_before, size: 40),
          ),
          onTap: () => Navigator.pop(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: FractionallySizedBox(
                  widthFactor: .32,
                  child: GestureDetector(
                    child: Hero(
                      tag: bookImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: bookImage,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImageViewer(url: bookImage,)),
                      );
                    },
                  )
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text(
                    bookTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.black
                    ),
                  ),
                ),
              ),
              _info(),
            ],
          ),
        )
      ],
    );
  }

  Widget _info(){
    if(title != null){
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Center( child: CircularProgressIndicator(strokeWidth: 1.5) ),
      );
    }

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Text(
              book['author'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                color: Colors.black54
              ),
            ),
          ),
        ),
        _review(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyButton(
              buttonText: 'Detalles',
              fontSize: 14,
              rightColor: Colors.white,
              leftColor: Colors.white,
              textColor: Colors.blueAccent,
              action: (){
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookDescriptionScreen(
                    book: book,
                    title: book['title'],
                    image: book['image'],
                    url: book['description_url'],
                  )),
                );
              },
            ),
            SizedBox(width: 15),
            RentButton(
              url: book['description_url'],
              title: book['title'],
              fontSize: 14,
            )
          ],
        )
      ],
    );
  }

  Widget _review(){
    if(book['review'] == null && book['video'] != null){
      YoutubePlayerController _controller = YoutubePlayerController(
        initialVideoId: '',
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );

      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: YoutubePlayer(
          controller: _controller,
          progressIndicatorColor: Colors.amber,
          controlsTimeOut: Duration(seconds: 1),
          progressColors: ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {
            int startIn = int.parse(book['video']['start_in']);
            _controller.cue(book['video']['id'], startAt: startIn);
          },
        ),
      );
    }

    if(book['review'] == null && book['video'] == null) return SizedBox();

    String review = book['review'].replaceAll('<br>', '\n');

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
        child: Text(
          review,
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14, 
            color: Colors.black87
          ),
        ),
      ),
    );
  }
 
}
