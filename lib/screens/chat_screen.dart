import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: Text('María'),
        trailing: GestureDetector(
          child: Text(
            'Opciones', 
            style: TextStyle(
              color: CupertinoColors.activeBlue
            )
          ),
          onTap: (){
            showCupertinoModalPopup(
              context: context,
              builder: (context){
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
                        style: TextStyle(color: CupertinoColors.destructiveRed),
                      ),
                      onPressed: () => Navigator.pop(context), 
                    ),
                  ],
                );
              }
            );
          },
        )
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Expanded(
              child: Stack(
                children: <Widget>[

                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    reverse: true,
                    children: <Widget>[

                      you(),
                      me(),
                      
                    ],
                  ),

                  Card(
                    margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Icon(CupertinoIcons.check_mark_circled, size: 30, color: CupertinoColors.activeGreen,),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 4,),
                                
                                Text(
                                  '¡Accediste a prestarle el libro a María!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Lato',
                                      color: CupertinoColors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: 'Cuando se encuentren, escaneá su '),
                                      TextSpan(text: 'código QR', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: ' para registrar la entrega.'),
                                    ],
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CupertinoButton(
                                    padding: EdgeInsets.all(0),
                                    child: Text('Escanear código QR'), 
                                    onPressed: (){}
                                  )
                                )

                              ],
                            ),
                          )
                          
                        ],
                      ),
                    ),
                  )

                ],
              )
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CupertinoTextField(
                        minLines: 1,
                        maxLines: 5,
                        placeholder: 'Escribe aquí',
                        padding: EdgeInsets.all(8),
                      ),
                    )
                  ),

                  CupertinoButton(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: Icon(Icons.send, size: 26,), 
                    onPressed: (){}
                  )

                ],
              ),
            )
            
          ],
        )
      )
    );
  }
}

Widget you(){
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
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              'Bueno dale 😂',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                // color: Colors.white
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget me(){
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
              borderRadius: BorderRadius.circular(8)
            ),
            child: Text(
              'Hola, quiero prestarte el libro, cuando podrías pasar a buscarlo?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    ),
  );
}