import 'package:flutter/material.dart';

class MyStep extends StatelessWidget {
  final String step;
  const MyStep({Key key, this.step}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 10),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                step, 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                )
              )
            ),
          ),
          Text(
            'Paso $step de 2',
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ],
      ),
    );
  }
}