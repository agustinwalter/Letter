import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final child;
  final color;
  const MyCard({Key key, this.child, this.color: Colors.white}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: color,
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
        child: child
      )
    );
  }
}