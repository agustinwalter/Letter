import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String title, description, primaryButtonText, secondaryButtonText;
  final Color primaryButtonTextColor, secondaryButtonTextColor, backgroundIconColor1, backgroundIconColor2;
  final IconData icon;
  final bool showSecondaryButton;
  final primaryButtonAction, secondaryButtonAction;

  const MyDialog({Key key, this.title, this.description, this.primaryButtonText, this.primaryButtonTextColor, this.backgroundIconColor2, this.icon, this.secondaryButtonText, this.secondaryButtonTextColor, this.showSecondaryButton, this.backgroundIconColor1, this.secondaryButtonAction, this.primaryButtonAction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  
  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Dialog
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              // Description
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),

              // Primary button
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: primaryButtonAction,
                  child: Text(primaryButtonText),
                  textColor: primaryButtonTextColor,
                ),
              ),

              // Secondary button
              Container(
                child: !showSecondaryButton ? Container() :
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: secondaryButtonAction,
                    child: Text(secondaryButtonText),
                    textColor: secondaryButtonTextColor,
                  ),
                ),
              )
                
            ],
          ),
        ),
        
        // Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: backgroundIconColor2,
                gradient: LinearGradient(
                  colors: [backgroundIconColor2, backgroundIconColor1],
                  begin: Alignment.centerRight,
                  end: Alignment(-1.0, -1.0)
                ),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Icon(icon, color: Colors.white, size: 50),
            ),
          ],
        ),

      ],
    );
  }
}

class Consts {
  Consts._();
  static const double padding = 16;
  static const double avatarRadius = 53;
}