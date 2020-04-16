import 'package:flutter/material.dart';
import 'package:letter/widgets/addressForm.dart';
import 'package:letter/widgets/my_step.dart';

class SubsStepOneScreen extends StatefulWidget {
  @override
  _SubsStepOneScreenState createState() => _SubsStepOneScreenState();
}

class _SubsStepOneScreenState extends State<SubsStepOneScreen> {
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
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MyStep(step: '1'),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Agrega una dirección de envío',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              AdressForm(actionAfterSave: 'GO_TO_COMPLETE_SUBSCRIPTION')
            ],
          );
        }
      )
    );
  }
}