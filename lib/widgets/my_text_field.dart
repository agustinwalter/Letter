import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final bool showSadow, obscureText, autovalidate;
  final IconData prefixIcon;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final actionLeft, validator, onFieldSubmitted;
  final EdgeInsetsGeometry margin;
  final TextEditingController controller;
  final double width;
  final BorderRadiusGeometry borderRadius;
  const MyTextField({Key key, this.showSadow: true, this.hintText, this.prefixIcon, this.obscureText: false, this.textInputAction, this.keyboardType, this.actionLeft, this.margin, this.controller, this.width:1, this.validator, this.autovalidate: false, this.onFieldSubmitted, this.borderRadius}) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool showClearButton = false;
  BorderRadiusGeometry borderRadius = BorderRadius.all(Radius.circular(15));
  
  @override
  void initState() {
    super.initState();
    widget.controller.addListener((){
      setState(() {
        if(widget.controller.text.length > 0) showClearButton = true;
        else showClearButton = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double w_100 = MediaQuery.of(context).size.width;

    if(widget.borderRadius != null) borderRadius = widget.borderRadius;

    return Container(
      margin: widget.margin,
      width: w_100 * widget.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: !widget.showSadow ? [] : [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 10,
            spreadRadius: 5,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        controller: widget.controller,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        validator: widget.validator,
        autovalidate: widget.autovalidate,
        decoration: InputDecoration(
          contentPadding: widget.prefixIcon == null ? EdgeInsets.fromLTRB(10, 14, 0, 14): EdgeInsets.only(top: 14),
          hintText: widget.hintText,
          border: InputBorder.none,
          prefixIcon: widget.prefixIcon == null ? null :
          IconButton(
            icon: Icon(widget.prefixIcon),
            onPressed: widget.actionLeft
          ),
          suffixIcon: !showClearButton ? null :
          IconButton(
            icon: Icon(Icons.close, color: Colors.black54,),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => widget.controller.clear());
            }
          ),
        ),
        onFieldSubmitted: widget.onFieldSubmitted,
      )
    );
  }
}