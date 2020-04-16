import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/widgets/addressForm.dart';

class AddAddressScreen extends StatefulWidget {
  final String appBarTitle;
  const AddAddressScreen({Key key, this.appBarTitle}) : super(key: key);
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
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
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.appBarTitle,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return AdressForm(actionAfterSave: 'BACK');
        }
      )
    );
  }
}