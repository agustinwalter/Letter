import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user_model.dart';
import 'package:letter/widgets/rent_button.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class BookDescriptionScreen extends StatefulWidget {
  final String tag, image, title, url;
  final book;
  const BookDescriptionScreen({Key key, this.tag, this.image, this.title, this.url, this.book}) : super(key: key);
  @override
  _BookDescriptionScreenState createState() => _BookDescriptionScreenState();
}

class _BookDescriptionScreenState extends State<BookDescriptionScreen> {
  Map<String, dynamic> bookInfo = {
    'author': ''
  };
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookBar(
        title: widget.book['title'],
        author: widget.book['author'],
        image: widget.book['image'],
        url: widget.book['description_url'],
      ),
      body: ListView.builder(
            itemCount: 1,
            padding: EdgeInsets.only(top: 30),
            itemBuilder: (context, index){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _messageCard(),
                  _videoCard(),
                  _infoCard(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: _reviewCard(),
                  )
                ],
              );
            },
          ),
    );
  }

  Widget _messageCard(){
    return Consumer<UserModel>(
      builder: (context, user, child) {
        String bookStatus = user.getBookRentedStatus();
        String rentedBookLink = user.getBookRentedLink();
        String message = '';
        IconData icon = Icons.info_outline;
        if(bookStatus == null) return SizedBox();
        if(rentedBookLink == widget.book['url']){
          if(bookStatus == 'PENDING_APPROVAL'){ 
            Map<dynamic, dynamic> addressMap = user.getAddress();
            String address = '${addressMap['street']} ${addressMap['number']}, ${addressMap['city']} ${addressMap['postal_code']}, ${addressMap['province']}';
            message = 'Estamos preparando el libro, lo llevaremos a "$address" dentro de los próximos días. Te mantendremos informada/o vía email.';
          }else if(bookStatus == 'RENTED'){
            icon = Icons.done;
            message = 'Este libro está en tus manos, esperamos que lo disfrutes :)';
          }else if(bookStatus == 'PENDING_RETURN'){
            Map<dynamic, dynamic> addressMap = user.getAddress();
            String address = '${addressMap['street']} ${addressMap['number']}, ${addressMap['city']}';
            message = 'Pronto pasaremos a buscar el libro por "$address". Te mantendremos informada/o vía email.';
          }
        }else return SizedBox();

        return FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                  spreadRadius: 2.5,
                  offset: Offset(5, 5),
                )
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  icon,
                  size: 23, 
                  color: Colors.lightBlueAccent
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(message),
                ),
              ],
            ),
          ),
        );    
      }
    );
  }

  Widget _videoCard(){
    if(widget.book['video'] == null) return SizedBox();

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              spreadRadius: 2.5,
              offset: Offset(5, 5),
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.book['video']['type'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10,),
            
            YoutubePlayer(
              controller: _controller,
              progressIndicatorColor: Colors.amber,
              controlsTimeOut: Duration(seconds: 1),
              progressColors: ProgressBarColors(
                playedColor: Colors.amber,
                handleColor: Colors.amberAccent,
              ),
              onReady: () {
                int startIn = int.parse(widget.book['video']['start_in']);
                _controller.cue(widget.book['video']['id'], startAt: startIn);
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.play_arrow),
                      Text('Ver en Youtube'),
                    ],
                  ),
                  textColor: Colors.blueAccent,
                  onPressed: () async {
                    String link = 'https://www.youtube.com/watch?v=${widget.book['video']['id']}?t=${widget.book['video']['start_in']}';
                    await launch(link);
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _reviewCard(){
    String review = widget.book['review'];
    if(review == null){
      return SizedBox();
    }else{
      review = review.replaceAll('<br>', '\n');
    }

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              spreadRadius: 2.5,
              offset: Offset(5, 5),
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Reseña',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Text( review )
          ],
        ),
      ),
    );
  }

  Widget _infoCard(){
    Map<dynamic, dynamic> details = widget.book['details'];

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              spreadRadius: 2.5,
              offset: Offset(5, 5),
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Detalles del libro',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _deltail('Formato', 'Papel'),
            Container(
              child: details['pages'] == null ? SizedBox() : 
              _deltail('Páginas', details['pages']),
            ),
            Container(
              child: details['weight'] == null ? SizedBox() : 
              _deltail('Peso', details['weight']),
            ),
            Container(
              child: details['edition'] == null ? SizedBox() : 
              _deltail('Edición', details['edition']),
            ),
            Container(
              child: details['language'] == null ? SizedBox() : 
              _deltail('Idioma', details['language']),
            ),
            Container(
              child: details['isbn'] == null ? SizedBox() : 
              _deltail('ISBN', details['isbn']),
            ),
          ],
        ),
      ),
    );
    
  }

  Widget _deltail(String key, String value){
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: '$key: ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '$value'),
          ]
        )
      ),
    );
  }

}

class BookBar extends StatelessWidget implements PreferredSizeWidget {
  final String title, author, image, url;

  const BookBar({Key key, this.title, this.author, this.image, this.url}) : super(key: key);
  
  @override
  Size get preferredSize => Size.fromHeight(190);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 35, 20, 15),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Book info
          Container(
            width: screenWidth * .65,
            padding: EdgeInsets.only(right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Back button
                GestureDetector(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                // Book title
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 7, 0, 0),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),
                  ),
                ),
                // Author
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Text(
                    author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                    )
                  ),
                ),
                // Button
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RentButton(
                        url: url,
                        title: title,
                        fontSize: 14,
                        isGreen: true,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Book image
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              height: 120, 
              width: 85,
              fit: BoxFit.cover,
              imageUrl: image,
              errorWidget: (context, url, error) {
                return Container(
                  height: 120,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
        ],
      ),
    );
  }
}