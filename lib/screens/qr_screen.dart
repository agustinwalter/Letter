import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatelessWidget {
  final String name;
  const QrScreen({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Código QR'),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.extraLightBackgroundGray,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Lato',
                        color: CupertinoColors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Pídele a '),
                        TextSpan(text: '$name', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(text: ' que escanee el siguiente código QR, así registraremos que entregaste el libro.'),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 3,
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    size: screenWidth * .8,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}