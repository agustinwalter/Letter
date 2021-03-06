import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:provider/provider.dart';
import 'add_image_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool showButton = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Configuración'),
        ),
        child: SafeArea(child: Consumer<User>(builder: (context, user, child) {
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: image(user.dataV['image']),
                        backgroundColor: Colors.transparent,
                      ),
                      Column(
                        children: [
                          RaisedButton.icon(
                            elevation: 0,
                            color: CupertinoColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: CupertinoColors.activeBlue)),
                            icon: Icon(Icons.image, color: CupertinoColors.activeBlue),
                            label: Text(
                              user.dataV['image'] == '' ? 'Subir foto' : 'Cambiar foto',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'Lato', color: CupertinoColors.activeBlue),
                            ),
                            onPressed: () async {
                              final url = await Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => AddImageScreen(
                                        uid: user.data.uid,
                                      )));
                              if (url != null) {
                                Firestore.instance
                                    .document('users/${user.data.uid}')
                                    .updateData({'image': url});
                              }
                            },
                          ),
                          RaisedButton.icon(
                            elevation: 0,
                            color: CupertinoColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: CupertinoColors.destructiveRed)),
                            icon: Icon(Icons.delete, color: CupertinoColors.destructiveRed),
                            label: Text(
                              'Eliminar foto',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'Lato', color: CupertinoColors.destructiveRed),
                            ),
                            onPressed: () {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext context) => CupertinoAlertDialog(
                                        title: Text("Eliminar foto"),
                                        content: Text('¿Deseas eliminar tu foto de perfil?'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            isDefaultAction: true,
                                            child: Text("Cancelar"),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                          CupertinoDialogAction(
                                            isDestructiveAction: true,
                                            child: Text('Eliminar',
                                                style: TextStyle(color: CupertinoColors.destructiveRed)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Provider.of<User>(context, listen: false).deleteImage();
                                            },
                                          )
                                        ],
                                      ));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: Text(
                      'Tu nombre:',
                      style: TextStyle(fontSize: 20, fontFamily: 'Lato', fontWeight: FontWeight.w300),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.text,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      placeholder: 'Ej. Juan Pérez',
                    ),
                  ),
                  showButton
                      ? Center(
                          child: CupertinoButton(
                              color: CupertinoColors.activeBlue,
                              child: Text('Guardar cambios'),
                              onPressed: () {}),
                        )
                      : SizedBox()
                ],
              ),
            ],
          );
        })));
  }

  image(image) {
    if (image == '') return AssetImage('assets/img/avatar.jpg');
    return NetworkImage(image);
  }
}
