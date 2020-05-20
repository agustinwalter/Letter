import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool loading;
  const Loader(this.loading);
  
  @override
  Widget build(BuildContext context) {
    if(loading){
      return Opacity(
        opacity: .8,
        child: Container(
          color: CupertinoColors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ CircularProgressIndicator() ],
            ),
          ),
        ),
      );
    }
    return SizedBox();
  }
}