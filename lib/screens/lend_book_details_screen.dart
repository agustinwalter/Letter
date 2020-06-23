// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:letter/models/user.dart';
import 'package:letter/screens/chat_screen.dart';
import 'package:letter/screens/opinions_screen.dart';
import 'package:provider/provider.dart';
// import 'package:quickblox_sdk/auth/module.dart';
// import 'package:quickblox_sdk/chat/constants.dart';
// import 'package:quickblox_sdk/models/qb_dialog.dart';
// import 'package:quickblox_sdk/models/qb_message.dart';
// import 'package:quickblox_sdk/models/qb_user.dart';
// import 'package:quickblox_sdk/quickblox_sdk.dart';

class LendBookDetails extends StatefulWidget {
  final String bookName;
  const LendBookDetails({Key key, this.bookName}) : super(key: key);
  @override
  _LendBookDetailsState createState() => _LendBookDetailsState();
}

class _LendBookDetailsState extends State<LendBookDetails> {
  // lendBook() async {
  //   try {
  //     Map<String, Object> chat = await QB.settings.get();
  //     if(chat['appId'] == null){
  //       // Inicio el chat, si no está iniciado
  //       await QB.settings.init(
  //         '81809', 
  //         'rPPw4My-Lb3a8H6', 
  //         'eYx26gXM82zd5zQ', 
  //         'KZVxbhgWB_cz-xsx9Lrw'
  //       );
  //     }

  //     // Obtengo el email
  //     final FirebaseAuth _auth = FirebaseAuth.instance;
  //     FirebaseUser currentUser = await _auth.currentUser();
  //     String email = currentUser.email;

  //     // Obtengo el password para loggear en el chat
  //     DocumentSnapshot userData = await Firestore.instance.document('users/${currentUser.uid}').get();
  //     String password = userData.data['chatPassword'];

  //     if(password == null){
  //       // Si no hay password, no hay usuario. Creo al usuario
  //       password = '';
  //       Random rng = Random();
  //       for (int i = 0; i < 8; i++) {
  //         password += rng.nextInt(10).toString();
  //       }
  //       QBUser user = await QB.users.createUser(email, password);
  //       Firestore.instance.document('users/${currentUser.uid}').updateData({
  //         'chatPassword': password,
  //         'chatUserId': user.id
  //       });
  //     }

  //     int userId;
  //     try {
  //       // El usuario ya está loggeado
  //       await QB.auth.getSession();
  //       userId = userData.data['chatUserId'];
  //     } on PlatformException catch (e) {
  //       // Loggeo al usuario
  //       QBLoginResult result = await QB.auth.login(email, password);
  //       userId = result.qbUser.id;
  //     }

  //     bool isConnected = await QB.chat.isConnected();
  //     if(!isConnected){
  //       // Si no está conectado, lo conecto al chat
  //       await QB.chat.connect(userId, password);
  //     }

  //     Map<dynamic, dynamic> userDialogs = userData.data['dialogs'];
  //     final int chatUserId = 107240342;
  //     // final String chatFirstName = 'Sofía';
      
  //     String dialogId;
  //     createDialog() async {
  //       QBDialog createdDialog = await QB.chat.createDialog(
  //         [107242615, chatUserId],
  //         'Chat Name',
  //         dialogType: QBChatDialogTypes.CHAT
  //       );
  //       dialogId = createdDialog.id;
  //       Firestore.instance.document('users/${currentUser.uid}').updateData({
  //         'dialogs.$chatUserId': dialogId
  //       });
  //     }

  //     if(userDialogs == null){
  //       // Creo el diálogo
  //       createDialog();
  //     }else{
  //       if(userDialogs[chatUserId.toString()] == null){
  //         // Creo el diálogo
  //         createDialog();
  //       }else{
  //         // Lo uno al diálogo
  //         dialogId = userDialogs[chatUserId.toString()];
  //         QB.chat.joinDialog(dialogId);
  //       }
  //     }

  //     // await QB.chat.sendMessage(
  //     //   dialogId,
  //     //   body: "Hola, quiero prestarte el libro!",
  //     //   saveToHistory: true
  //     // );

  //     List<QBMessage> messages = await QB.chat.getDialogMessages(
  //       dialogId, 
  //       // sort: qbSort, 
  //       // filter: qbFilter, 
  //       // limit: limit, 
  //       // skip: skip, 
  //       markAsRead: false
  //     );
  //     for (QBMessage message in messages) {
  //       print(message.senderId);
  //       print(message.body);
  //       print(message.dateSent);
  //       print('');
  //     }

  //   } on PlatformException catch (e) {
  //     print('--------------------------CHAT ERROR----------------------------');
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getLendUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.bookName),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.extraLightBackgroundGray,
          child: ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: <Widget>[
              Consumer<User>(
                builder: (context, user, child) {
                  return Column(
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: 'Si tienes el libro  '),
                              TextSpan(text: '"${widget.bookName}"', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ', puedes prestárselo a ${user.lendUserInfo['name']}.'),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        height: 150,
                        width: 140,
                        margin: EdgeInsets.only(bottom: 20),
                        child: Stack(
                          children: <Widget>[

                            CircleAvatar(
                              radius: 70,
                              backgroundImage: image(user.lendUserInfo['image']),
                              backgroundColor: Colors.transparent,
                            ),

                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  child: Text(
                                    user.lendUserInfo['name'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Lato'
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),

                      reputationCard(screenWidth, user.lendUserInfo['reputation'], user.lendUserInfo['name']),
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,20,0,25),
                        child: Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(CupertinoIcons.location_solid),

                                SizedBox(width: 10,),

                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Lato',
                                      color: CupertinoColors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: 'Vive a '),
                                      TextSpan(text: getDistance(user.lendUserInfo['distance']), style: TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          )
                        ),
                      ),

                      CupertinoButton(
                        color: CupertinoColors.activeBlue,
                        child: Text('Prestar libro'),
                        onPressed: (){
                          Navigator.of(context).push(
                            CupertinoPageRoute(builder: (context) => ChatScreen())
                          );
                        },
                      )

                    ],
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  String getDistance(distance){
    if(distance < 1000) return '$distance metros';
    return '${(distance / 1000).round()}km';
  }

  image(image){
    if(image == null) return AssetImage('assets/img/avatar.jpg');
    return NetworkImage(image);
  }

  Widget reputationCard(double screenWidth, int reputation, String name){
    String titleCard = 'Aún no recibió libros prestados';
    String messageCard = '$name no a leído ningún libro prestado por lo que no podemos calcular su reputación.';
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
        titleCard = '$name tiene mala reputación'; 
        messageCard = 'Te recomendamos que no le prestes libros.'; 
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
        titleCard = 'Reputación media'; 
        messageCard = 'Es posible que $name haya devuelto libros en malas condiciones, te recomendamos que veas las opiniones de otros usuarios antes de prestarle un libro.'; 
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
        titleCard = '$name tiene buena reputación'; 
        messageCard = 'Devolvió todos los libros en perfecto estado.'; 
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
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.security),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text(
                    titleCard,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  Container(
                    width: screenWidth - 84,
                    margin: EdgeInsets.only(bottom: 12),
                    child: Text(
                      messageCard,
                      style: TextStyle(
                        fontSize: 16,
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
                    width: screenWidth - 84,
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
                  ) : SizedBox()
                
                ],
              )
            ],
          ),
        )
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

}