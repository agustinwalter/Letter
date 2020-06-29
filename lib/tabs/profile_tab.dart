import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:letter/screens/add_image_screen.dart';
import 'package:letter/screens/chat_screen.dart';
import 'package:letter/screens/opinions_screen.dart';
import 'package:letter/screens/qr_screen.dart';
import 'package:letter/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {  
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getProfileCards();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        color: CupertinoColors.extraLightBackgroundGray,
        child: Consumer<User>(
          builder: (context, user, child) {
            return Stack(
              children: <Widget>[

                Container(
                  height: 170,
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                  color: CupertinoColors.activeBlue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Text(
                            'Dinero ahorrado',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Lato',
                              color: CupertinoColors.white
                            ),
                          ),
    
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 50,
                                fontFamily: 'Lato',
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.w300
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '\$', style: TextStyle(fontSize: 30)),
                                TextSpan(text: user.dataV['money']),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                              
                      Container(
                        height: 110,
                        width: 100,
                        child: Stack(
                          children: <Widget>[

                            CircleAvatar(
                              radius: 50,
                              backgroundImage: image(user.dataV['image']),
                              backgroundColor: Colors.transparent,
                            ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Text(
                                    user.data.displayName.split(' ')[0],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Lato'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      )
                      
                    ],
                  ),
                ),
                
                ListView.builder(
                  padding: EdgeInsets.only(top: 170),
                  itemCount: user.profileCards.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if(i == user.profileCards.length){
                      return CupertinoButton(
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(
                            color: CupertinoColors.destructiveRed
                          ),
                        ), 
                        onPressed: () => Provider.of<User>(context, listen: false).signOut()
                      );
                    }
                    Map card = user.profileCards[i];
                    switch (card['type']) {
                      case 'add_photo': return addPhotoCard();
                      case 'delivery': return deliveryCard(user.profileCards[i]);
                      case 'received': return receivedCard(user.profileCards[i]);
                      case 'reputation': 
                        String name = user.data.displayName.split(' ')[0];
                        int reputation = user.dataV['reputation'];
                        return reputationCard(name, reputation);
                      case 'configuration': return configurationCard();
                      default: return SizedBox();
                    }
                  }
                ),

              ],
            );
          }
        )    
      ),
    );
  }

  image(image){
    if(image == '') return AssetImage('assets/img/avatar.jpg');
    return NetworkImage(image);
  }

  Widget addPhotoCard(){
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      padding: EdgeInsets.only(top: 20),
      child: GestureDetector(
        child: Card(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Icon(CupertinoIcons.photo_camera, size: 30),

                SizedBox(width: 8),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,6,0,5),
                        child: Text(
                          '¡Sube una foto!',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      Text(
                        'Las personas confiaran más en ti si tienes una foto de perfil.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Lato',
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 8),
                        width: screenWidth - 84,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subir foto',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Lato',
                                color: CupertinoColors.activeBlue
                              ),
                            ),
                            Icon(CupertinoIcons.forward),
                          ],
                        ),
                      ) 

                    ],
                  ),
                )
                
              ],
            ),
          ),
        ),
        onTap: (){
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context){
              return AddImageScreen();
            })
          );
        },
      ),
    );
  }

  Widget deliveryCard(Map cardData){
    String titleCard = 'Accediste a prestar “${cardData['book']}”';
    String messageCard = 'Coordina un punto de encuentro con ${cardData['name']} para entregarle el libro.';
    switch (cardData['status']) {
      case 'delivered':
        titleCard = 'Prestaste “${cardData['book']}”';
        messageCard = '${cardData['name']} está leyendo el libro, pronto te lo devolverá.';
        break;
      case 'opinion':
        titleCard = 'Te devolvieron “${cardData['book']}”';
        messageCard = '¿Nos darías una opinión sobre ${cardData['name']} y el estado en que devolvió el libro?';
        break;
      default:
    }
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      child: Card(
        margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Icon(CupertinoIcons.book, size: 30),

              SizedBox(width: 8),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    // Título
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,6,0,5),
                      child: Text(
                        titleCard,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    // Mensaje
                    Text(
                      messageCard,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ),

                    SizedBox(height: 5,),

                    // Botón uno
                    (cardData['status'] != 'opinion') ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chatear con ${cardData['name']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.activeBlue
                            ),
                          ),
                          Icon(CupertinoIcons.forward, color: CupertinoColors.activeBlue,),
                        ],
                      ),
                      onPressed: (){},
                    ) : SizedBox(),

                    // Botón dos
                    (cardData['status'] != 'opinion') ? FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mostrar código QR',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.activeBlue
                            ),
                          ),
                          Icon(CupertinoIcons.forward, color: CupertinoColors.activeBlue,),
                        ],
                      ),
                      onPressed: (){
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => QrScreen(
                            name: cardData['name'],
                          ))
                        );
                      },
                    ) : SizedBox(),

                    // Botón tres
                    (cardData['status'] == 'pre_delivery' || cardData['status'] == 'opinion') ? 
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cardData['status'] == 'pre_delivery' ? 'Cancelar préstamo' : 'Dar mi opinión',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: cardData['status'] == 'pre_delivery' ? 
                                CupertinoColors.destructiveRed : 
                                CupertinoColors.activeBlue,
                            ),
                          ),
                          cardData['status'] == 'opinion' 
                            ? Icon(CupertinoIcons.forward, color: CupertinoColors.activeBlue,) 
                            : SizedBox(),
                        ],
                      ),
                      onPressed: (){},
                    ) : SizedBox(),

                  ],
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }

  Widget receivedCard(Map cardData){
    String titleCard = 'Accedieron a prestarte “${cardData['book']}”';
    String messageCard = 'Coordina un punto de encuentro con ${cardData['name']} para que te entregue el libro.';
    switch (cardData['status']) {
      case 'received':
        titleCard = 'Te prestaron “${cardData['book']}”';
        messageCard = '¡Esperamos que disfrutes tu lectura!';
        break;
      default:
    }
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      child: Card(
        margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Icon(CupertinoIcons.book, size: 30),

              SizedBox(width: 8),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    // Título
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,6,0,5),
                      child: Text(
                        titleCard,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    // Mensaje
                    Text(
                      messageCard,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ),

                    SizedBox(height: 5,),

                    // Botón uno
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chatear con ${cardData['name']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.activeBlue
                            ),
                          ),
                          Icon(CupertinoIcons.forward, color: CupertinoColors.activeBlue,),
                        ],
                      ),
                      onPressed: (){
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => ChatScreen(
                            name: cardData['name'],
                            otherId: cardData['uid'],
                            bookName: cardData['book'],
                            bookAuthor: cardData['author'],
                            receiving: true,
                          ))
                        );
                      },
                    ),

                    // Botón dos
                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      child: Row(
                        children: [
                          Text(
                            'Escanear código QR',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.activeBlue
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        ScanResult result = await BarcodeScanner.scan();
                        print(result.rawContent);
                      },
                    )

                  ],
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }

  Widget reputationCard(String name, int reputation){
    String messageCard = 'Aún no leíste ningún libro prestado por lo que no podemos calcular tu reputación.';
    Map reputationBar = {
      'color0': CupertinoColors.inactiveGray,
      'color1': CupertinoColors.inactiveGray,
      'color2': CupertinoColors.inactiveGray,
      'opacity0': .8,
      'opacity1': .8,
      'opacity2': .8,
      'height0': 8.0,
      'height1': 8.0,
      'height2': 8.0,
    };

    switch (reputation) {
      case 1: 
        messageCard = 'Tienes una mala reputación, es probable que nadie quiera prestarte libros.'; 
        reputationBar = {
          'color0': CupertinoColors.destructiveRed,
          'color1': CupertinoColors.systemYellow,
          'color2': CupertinoColors.activeGreen,
          'opacity0': 1.0,
          'opacity1': .3,
          'opacity2': .3,
          'height0': 14.0,
          'height1': 8.0,
          'height2': 8.0,
        };
      break;
      case 2:
        messageCard = 'Parece que has devuelto libros en malas condiciones por lo que te asignamos una reputación regular.'; 
        reputationBar = {
          'color0': CupertinoColors.destructiveRed,
          'color1': CupertinoColors.systemYellow,
          'color2': CupertinoColors.activeGreen,
          'opacity0': .3,
          'opacity1': 1.0,
          'opacity2': .3,
          'height0': 8.0,
          'height1': 14.0,
          'height2': 8.0,
        };
      break;
      case 3: 
        messageCard = '¡Sigue así! Tienes la mejor reputación de Letter.'; 
        reputationBar = {
          'color0': CupertinoColors.destructiveRed,
          'color1': CupertinoColors.systemYellow,
          'color2': CupertinoColors.activeGreen,
          'opacity0': .3,
          'opacity1': .3,
          'opacity2': 1.0,
          'height0': 8.0,
          'height1': 8.0,
          'height2': 14.0,
        };
      break;
      default:
    }

    return GestureDetector(
      child: Container(
        color: CupertinoColors.extraLightBackgroundGray,
        child: Card(
          elevation: 3,
          margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Icon(CupertinoIcons.person, size: 30,),
                
                SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,6,0,5),
                      child: Text(
                        'Reputación',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    Container(
                      width: screenWidth - 86,
                      margin: EdgeInsets.only(bottom: 12),
                      child: Text(
                        messageCard,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Lato'
                        ),
                      ),
                    ),
                    
                    Row(
                      children: [
                        Opacity(
                          opacity: reputationBar['opacity0'],
                          child: Container(
                            height: reputationBar['height0'],
                            width: (screenWidth / 3) - 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(reputationBar['height0'] / 2),
                              color: reputationBar['color0']
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: reputationBar['opacity1'],
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            height: reputationBar['height1'],
                            width: (screenWidth / 3) - 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(reputationBar['height1'] / 2),
                              color: reputationBar['color1']
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: reputationBar['opacity2'],
                          child: Container(
                            height: reputationBar['height2'],
                            width: (screenWidth / 3) - 34,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(reputationBar['height2'] / 2),
                              color: reputationBar['color2']
                            ),
                          ),
                        ),
                      ],
                    ),

                    (reputation != 0) ? Container(
                      margin: EdgeInsets.only(top: 12),
                      width: screenWidth - 86,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ver opiniones',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.activeBlue
                            ),
                          ),
                          Icon(CupertinoIcons.forward),
                        ],
                      ),
                    ) : SizedBox(height: 5)
                  
                  ],
                )
              ],
            ),
          )
        ),
      ),
      onTap: (){
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (context){
            return OpinionsScreen(name: name);
          })
        );
      },
    );
  }

  Widget configurationCard(){
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      child: GestureDetector(
        child: Card(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Icon(CupertinoIcons.settings, size: 30,),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 0, 0),
                    child: Text(
                      'Configuración',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                Icon(CupertinoIcons.forward),

              ],
            )
          )
        ),
        onTap: (){
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (context) => SettingScreen())
          );
        },
      ),
    );
  }
  
}