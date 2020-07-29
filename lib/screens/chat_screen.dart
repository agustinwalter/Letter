import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String name, otherId, bookName, bookAuthor;
  final bool receiving;
  const ChatScreen(
      {Key key,
      this.name,
      this.otherId,
      this.bookName,
      this.bookAuthor,
      this.receiving: false})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DocumentSnapshot lendData;
  bool loadingMessages = true;
  CubeDialog dialog;
  TextEditingController textController = TextEditingController();
  List<CubeMessage> messages;
  CubeUser cubeUser, otherCubeUser;
  StreamSubscription<CubeMessage> cubeMessageStream;
  String notificationToken;
  User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<User>(context, listen: false);
    // user
    //     .checkLendBook(widget.otherId, widget.bookName, widget.bookAuthor,
    //         widget.receiving)
    //     .then((doc) => setState(() => lendData = doc));
    cubeUser = user.cubeUser;
    getToken(user);
    initChat();
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    if (cubeMessageStream != null) cubeMessageStream.cancel();
  }

  initChat() async {
    try {
      // Obtengo o creo un diálogo entre ambos usuarios
      otherCubeUser = await getUserByLogin(widget.otherId);
      PagedResult<CubeDialog> dialogs = await getDialogs();
      for (CubeDialog d in dialogs.items) {
        if (d.occupantsIds[0] == cubeUser.id &&
                d.occupantsIds[1] == otherCubeUser.id ||
            d.occupantsIds[1] == cubeUser.id &&
                d.occupantsIds[0] == otherCubeUser.id) {
          dialog = d;
        }
      }
      if (dialog == null) {
        setState(() {
          loadingMessages = false;
          messages = [];
        });
        dialog = await createDialog(CubeDialog(CubeDialogType.PRIVATE,
            occupantsIds: [otherCubeUser.id]));
      } else {
        // Obtengo el historial de mensajes
        GetMessagesParameters params = GetMessagesParameters();
        params.limit = 100;
        params.markAsRead = true;
        params.sorter = RequestSorter(OrderType.DESC, "", "date_sent");
        PagedResult<CubeMessage> m =
            await getMessages(dialog.dialogId, params.getRequestParameters());
        setState(() {
          loadingMessages = false;
          messages = m.items;
        });
      }
      // Escucho nuevos mensajes
      ChatMessagesManager chatMessagesManager =
          CubeChatConnection.instance.chatMessagesManager;
      cubeMessageStream =
          chatMessagesManager.chatMessagesStream.listen((newMessage) {
        if (mounted) setState(() => messages.insert(0, newMessage));
      });
      cubeMessageStream.onError((error) {
        print(error);
      });
    } catch (e) {
      print(e);
    }
  }

  sendMessage() async {
    if (textController.text.length > 0) {
      // Envío el mensaje
      CubeMessage message = CubeMessage();
      message.body = textController.text;
      message.dateSent = DateTime.now().millisecondsSinceEpoch;
      message.markable = true;
      message.saveToHistory = true;
      message.senderId = cubeUser.id;
      setState(() => messages.insert(0, message));
      dialog.sendMessage(message);
      // Envío la notificación
      if (notificationToken != null) {
        http.post(
            'https://us-central1-letter-bfbab.cloudfunctions.net/sendMessageNotification',
            body: {
              'name': user.data.displayName,
              'message': textController.text,
              'token': notificationToken
            });
      }
      textController.clear();
    }
  }

  getToken(user) async =>
      notificationToken = await user.getNotificationToken(widget.otherId);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        navigationBar: CupertinoNavigationBar(
            middle: Text(widget.name),
            trailing: GestureDetector(
              child: Text('Opciones',
                  style: TextStyle(color: CupertinoColors.activeBlue)),
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return CupertinoActionSheet(
                        title: Text('Opciones'),
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text('Ver perfil de María'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoActionSheetAction(
                            child: Text(
                              'Ya no quiero prestar el libro',
                              style: TextStyle(
                                  color: CupertinoColors.destructiveRed),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
                    });
              },
            )),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    // Cargando
                    Opacity(
                      opacity: loadingMessages ? 1 : 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Cargando mensajes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 5),
                                  width: 130,
                                  child: LinearProgressIndicator())
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Mensajes
                    messages != null
                        ? ListView.builder(
                            itemCount: messages.length,
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (messages[index].senderId == cubeUser.id)
                                return me(messages[index].body);
                              return you(messages[index].body);
                            })
                        : SizedBox(),


                    // Info
                    // infoCard()
                  ],
                )
              ),

              // Campo de texto
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CupertinoTextField(
                        controller: textController,
                        minLines: 1,
                        maxLines: 5,
                        placeholder: 'Escribe aquí',
                        padding: EdgeInsets.all(8),
                      ),
                    )),
                    CupertinoButton(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Icon(
                          Icons.send,
                          size: 26,
                        ),
                        onPressed: () => sendMessage())
                  ],
                ),
              )
            ],
          ))
        );
  }

  Widget infoCard() {
    if (lendData == null) return SizedBox();

    Map cardData = {
      'title': 'Accediste a prestar "${lendData.data['bookName']}"',
      'message':
          'Cuando te encuentres con ${widget.name}, pídele que escanee tu código QR para registrar la entrega.',
      'buttonText': 'Mostrar código QR'
    };
    if (widget.receiving) {
      // Estoy recibiendo el libro
      if (lendData.data['status'] == 0) {
        // Tarjeta de libro pre-recibido
        cardData = {
          'title': 'Accedieron a prestarte "${lendData.data['bookName']}"',
          'message':
              'Cuando te encuentres con ${widget.name}, escanea su código QR para registrar la entrega.',
          'buttonText': 'Escanear código QR'
        };
      } else {
        // Tarjeta de libro recibido
        cardData = {
          'title': 'Te prestaron "${lendData.data['bookName']}"',
          'message':
              'Cuando se lo devuelvas, escanea su código QR para registrar la devolución.',
          'buttonText': 'Escanear código QR'
        };
      }
    } else {
      // Estoy prestando el libro
      if (lendData.data['status'] == 1) {
        cardData = {
          'title': 'Prestaste "${lendData.data['bookName']}"',
          'message':
              'Cuando ${widget.name} te lo devuelva, pídele que escanee tu código QR para registrar la devolución.',
          'buttonText': 'Mostrar código QR'
        };
      }
    }

    return Opacity(
      opacity: .97,
      child: Card(
        margin: EdgeInsets.fromLTRB(7, 5, 7, 0),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                CupertinoIcons.check_mark_circled,
                size: 30,
                color: CupertinoColors.activeGreen,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Título
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 5),
                      child: Text(
                        cardData['title'],
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Mensaje
                    Text(
                      cardData['message'],
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Lato',
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    FlatButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cardData['buttonText'],
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Lato',
                              color: CupertinoColors.activeBlue,
                            ),
                          ),
                          !widget.receiving
                              ? Icon(
                                  CupertinoIcons.forward,
                                  color: CupertinoColors.activeBlue,
                                )
                              : SizedBox(),
                        ],
                      ),
                      onPressed: () {},
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

  Widget you(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget me(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: FractionallySizedBox(
        widthFactor: .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                  color: CupertinoColors.activeBlue,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16, fontFamily: 'Lato', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
