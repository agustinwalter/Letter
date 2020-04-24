import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letter/screens/chat_screen.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';

class LendBooksTab extends StatefulWidget {
  @override
  _LendBooksTabState createState() => _LendBooksTabState();
}

class _LendBooksTabState extends State<LendBooksTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      child: ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            child: Card(
              margin: EdgeInsets.only(bottom: 10),
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

                    Text(
                      '+500',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Lato',
                        color: CupertinoColors.activeBlue,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            onTap: (){
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (context){
                  return LendBookDetails(bookName: 'Título del libro');
                  // return ChatScreen();
                })
              );
            },
          );
        }
      ),
    );
  }
}

class LendBookDetails extends StatelessWidget {
  final String bookName;

  const LendBookDetails({Key key, this.bookName}) : super(key: key);

  lendBook() async {
    try {
      Map<String, Object> chat = await QB.settings.get();
      if(chat['appId'] == null){
        // Inicio el chat, si no está iniciado
        await QB.settings.init(
          '81809', 
          'rPPw4My-Lb3a8H6', 
          'eYx26gXM82zd5zQ', 
          'KZVxbhgWB_cz-xsx9Lrw'
        );
      }

      // Obtengo el email
      final FirebaseAuth _auth = FirebaseAuth.instance;
      FirebaseUser currentUser = await _auth.currentUser();
      String email = currentUser.email;

      // Obtengo el password para loggear en el chat
      DocumentSnapshot userData = await Firestore.instance.document('users/${currentUser.uid}').get();
      String password = userData.data['chatPassword'];

      if(password == null){
        // Si no hay password, no hay usuario. Creo al usuario
        password = '';
        Random rng = Random();
        for (int i = 0; i < 8; i++) {
          password += rng.nextInt(10).toString();
        }
        QBUser user = await QB.users.createUser(email, password);
        Firestore.instance.document('users/${currentUser.uid}').updateData({
          'chatPassword': password,
          'chatUserId': user.id
        });
      }

      int userId;
      try {
        // El usuario ya está loggeado
        await QB.auth.getSession();
        userId = userData.data['chatUserId'];
      } on PlatformException catch (e) {
        // Loggeo al usuario
        QBLoginResult result = await QB.auth.login(email, password);
        userId = result.qbUser.id;
      }

      bool isConnected = await QB.chat.isConnected();
      if(!isConnected){
        // Si no está conectado, lo conecto al chat
        await QB.chat.connect(userId, password);
      }

      Map<dynamic, dynamic> userDialogs = userData.data['dialogs'];
      final int chatUserId = 107240342;
      // final String chatFirstName = 'Sofía';
      
      String dialogId;
      createDialog() async {
        QBDialog createdDialog = await QB.chat.createDialog(
          [107242615, chatUserId],
          'Chat Name',
          dialogType: QBChatDialogTypes.CHAT
        );
        dialogId = createdDialog.id;
        Firestore.instance.document('users/${currentUser.uid}').updateData({
          'dialogs.$chatUserId': dialogId
        });
      }

      if(userDialogs == null){
        // Creo el diálogo
        createDialog();
      }else{
        if(userDialogs[chatUserId.toString()] == null){
          // Creo el diálogo
          createDialog();
        }else{
          // Lo uno al diálogo
          dialogId = userDialogs[chatUserId.toString()];
          QB.chat.joinDialog(dialogId);
        }
      }

      // await QB.chat.sendMessage(
      //   dialogId,
      //   body: "Hola, quiero prestarte el libro!",
      //   saveToHistory: true
      // );

      List<QBMessage> messages = await QB.chat.getDialogMessages(
        dialogId, 
        // sort: qbSort, 
        // filter: qbFilter, 
        // limit: limit, 
        // skip: skip, 
        markAsRead: false
      );
      for (QBMessage message in messages) {
        print(message.senderId);
        print(message.body);
        print(message.dateSent);
        print('');
      }

    } on PlatformException catch (e) {
      print('--------------------------CHAT ERROR----------------------------');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(bookName),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.extraLightBackgroundGray,
          child: ListView(
            padding: EdgeInsets.only(bottom: 20),
            children: <Widget>[
              Column(
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
                          TextSpan(text: 'Si tenés el libro  '),
                          TextSpan(text: '"Cien años de soledad"', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ', podés prestárselo a María y sumar '),
                          TextSpan(text: '500 puntos', style: TextStyle(color: CupertinoColors.activeBlue, fontWeight: FontWeight.bold)),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: 150,
                    width: 140,
                    child: Stack(
                      children: <Widget>[

                        CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          backgroundColor: Colors.transparent,
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'María',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Lato'
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(CupertinoIcons.check_mark_circled_solid, size: 20,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.security),
                          SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'María es de confianza',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Container(
                                width: screenWidth - 80,
                                child: Text(
                                  'Devolvió todos los libros en perfecto estado.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lato'
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ),

                  SizedBox(height: 20,),

                  Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
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
                                TextSpan(text: '2km', style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: ' de vos.'),
                              ],
                            ),
                          )

                        ],
                      ),
                    )
                  ),

                  SizedBox(height: 30,),

                  CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    child: Text('Prestar libro'),
                    onPressed: (){
                      // lendBook();

                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context){
                          return ChatScreen();
                        })
                      );                      

                    },
                  )

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}