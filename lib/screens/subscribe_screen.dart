import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:letter/screens/subs_step_one_screen.dart';

class SubscribeScreen extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  bool loading = false;
  String amount = '';

  @override
  void initState() {
    super.initState();
    http.get('http://data.fixer.io/api/latest?access_key=a3f742cabd91bbacb7a7ac1be3051994&symbols=USD,ARS&format=1')
    .then((Response res){
      var data = jsonDecode(res.body);
      setState(() {
        double a = data['rates']['ARS'] / data['rates']['USD'] * 2.99;
        amount = a.round().toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(null, 100),
        child: Container(
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
          padding: EdgeInsets.fromLTRB(20, 35, 20, 18),
          child: Stack(
            children: <Widget>[
              // Icon
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Suscríbete',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '¡Suscríbete por solo '),
                      TextSpan(text: 'AR\$179', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' mensuales y empieza a leer lo que quieras!'),
                    ]
                  )
                )
              ),

              FractionallySizedBox(
                widthFactor: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _checkMessage('Más de 8000 libros físicos a tu disposición'),
                      Divider(),
                      _checkMessage('Te regalamos el primer mes'),
                      Divider(),
                      _checkMessage('Envío a domicilio gratis, tanto para llevarte el libro como para ir a buscarlo'),
                      Divider(),
                      _checkMessage('Sin fecha límite de devolución, tomate el tiempo que quieras para leer cada obra'),
                    ]
                  )
                )
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                child: RaisedButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SubsStepOneScreen()),
                    ); 
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightBlueAccent,
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blueAccent],
                        begin: Alignment.centerRight,
                        end: Alignment(-1.0, -1.0)
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text('Suscribirme', style: TextStyle(fontSize: 17)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                ),
              ),

            ]
          ),

          Container(
            child: !loading ? Container() :
            Container(
              color: Color(0x99FFFFFF),
              child: Center(child: CupertinoActivityIndicator())
            ),
          ),
        ],
      )
    );
  }

  Widget _checkMessage(String message){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.done, 
          size: 30, 
          color: Colors.green
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(message),
        ),
      ],
    );
  }

}