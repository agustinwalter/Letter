// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:quickblox_sdk/auth/module.dart';
// import 'package:quickblox_sdk/chat/constants.dart';
// import 'package:quickblox_sdk/models/qb_dialog.dart';
// import 'package:quickblox_sdk/models/qb_message.dart';
// import 'package:quickblox_sdk/models/qb_user.dart';
// import 'package:quickblox_sdk/quickblox_sdk.dart';

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