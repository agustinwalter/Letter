import 'package:flutter/material.dart';
// import 'package:letter/screens/subs_form_screen.dart';
import 'package:letter/widgets/my_button.dart';
import 'package:letter/widgets/my_step.dart';
import 'package:url_launcher/url_launcher.dart';

class SubsStepTwoScreen extends StatefulWidget {
  final bool noFreeTrial;
  const SubsStepTwoScreen({Key key, this.noFreeTrial: false}) : super(key: key);
  @override
  _SubsStepTwoScreenState createState() => _SubsStepTwoScreenState();
}

class _SubsStepTwoScreenState extends State<SubsStepTwoScreen> {
  bool buttonAddressLoading = false;

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
      body: Column(
        children: <Widget>[
          MyStep(step: '2'),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Completa la suscripción',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Agrega los datos de tu tarjeta de crédito, no te cobraremos nada durante el primer mes. Luego se realizarán cobros mensuales de '),
                    TextSpan(text: 'AR\$179', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '. Puedes cancelar la suscripción en cualquier momento.'),
                  ]
                )
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 5),
            child: Text(
              'Pagos procesados por',
              style: TextStyle(
                fontSize: 14
              ),
            ),
          ),
          Image.asset('assets/img/mp-logo.png', width: 140),
          SizedBox(height: 20),
          MyButton(
            buttonText: 'Completar suscripción',
            fontSize: 17,
            action: () async {
              setState(() => buttonAddressLoading = true);
              String link = 'https://mpago.la/4grkfJ';
              if(widget.noFreeTrial) link = 'https://mpago.la/3tBZTZ';
              await launch(link, forceWebView: true, enableJavaScript: true);
              setState(() => buttonAddressLoading = false);
            },
            loading: buttonAddressLoading,
          ),
        ],
      ),
    );
  }
}