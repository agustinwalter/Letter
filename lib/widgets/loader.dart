import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final bool loading;
  const Loader(this.loading);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        color: CupertinoColors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CircularProgressIndicator()],
          ),
        ),
      );
    }
    return SizedBox();
  }
}
