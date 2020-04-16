import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String buttonText;
  final double fontSize;
  final action;
  final Color rightColor, leftColor, textColor;
  final bool loading;
  const MyButton({Key key, this.buttonText, this.fontSize, this.action, this.rightColor: Colors.lightBlueAccent, this.leftColor: Colors.blueAccent, this.textColor: Colors.white, this.loading: false}) : super(key: key);
  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: RaisedButton(
          onPressed: widget.loading ? (){} : widget.action,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              gradient: LinearGradient(
                colors: [widget.rightColor, widget.leftColor],
                begin: Alignment.centerRight,
                end: Alignment(-1.0, -1.0)
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: widget.loading ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CupertinoActivityIndicator(),
            ) : Text(
              widget.buttonText,
              style: TextStyle(fontSize: widget.fontSize),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textColor: widget.textColor,
          padding: const EdgeInsets.all(0.0),
        ),
      ),
    );
  }
}