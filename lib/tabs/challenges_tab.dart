import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallengesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
  
    return Container(
      color: CupertinoColors.extraLightBackgroundGray,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              levelCard(),

              // Mensaje de como sumar puntos
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 30, 14, 30),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Lato',
                      color: CupertinoColors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Sumá puntos '),
                      TextSpan(text: 'prestando libros', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' o cumpliendo los siguientes objetivos:'),
                    ],
                  ),
                )
              ),

              // Primer grupo de desafíos
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Conociendo Letter',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
              ),

              Container(
                height: 154,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .07),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    challengeCard(screenWidth, 'Creá tu lista de deseos', 'Agregá al menos tres libros que tengas ganas de leer.', 25, 'Completado', true, 1),
                    SizedBox(width: 5),
                    challengeCard(screenWidth, 'Completá tu perfil', 'Un perfil completo genera confianza en las personas.', 50, 'Completar perfil', false, .25),
                    SizedBox(width: 5),
                    challengeCard(screenWidth, 'Pedí un libro', 'Leé el primer libro que te presten de tu lista de deseos.', 100, 'Crear lista de deseos', false, 0)
                  ],
                ),
              ),

              // Segundo grupo de desafíos
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 30, 14, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lector/a apasionad@',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
              ),

              Container(
                height: 154,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .07),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    challengeCard(screenWidth, 'Leé 2 libros prestados', 'Leé 2 libros que te presten de tu lista de deseos.', 50, 'Crear lista de deseos', false, .5),
                    SizedBox(width: 5),
                    challengeCard(screenWidth, 'Leé 5 libros prestados', 'Leé 5 libros que te presten de tu lista de deseos.', 100, 'Crear lista de deseos', false, .25),
                    SizedBox(width: 5),
                    challengeCard(screenWidth, 'Leé 10 libros prestados', 'Leé 10 libros que te presten de tu lista de deseos.', 150, 'Crear lista de deseos', false, .1)
                  ],
                ),
              ),

              // Tercer grupo de desafíos
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 30, 14, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Prestamista',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),
              ),

              Container(
                height: 154,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * .07),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    challengeCard(screenWidth, 'Prestá tu primer libro', 'Rompé el hielo y prestale un libro a una persona.', 100, 'Prestar libros', false, 0),
                    SizedBox(width: 5),
                    challengeCard(screenWidth, 'Prestá 5 libros', 'Te falta prestar 5 libros para cumplir este desafío.', 150, 'Prestar libros', false, 0),
                    SizedBox(width: 5),
                    challengeCard(screenWidth, 'Prestá 10 libros', 'Te falta prestar 10 libros para cumplir este desafío.', 300, 'Prestar libros', false, 0)
                  ],
                ),
              )

            ],
          ),
        ],
      ),
    );

  }
}

Widget levelCard(){
  return Card(
    elevation: 3,
    margin: EdgeInsets.symmetric(horizontal: 15),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
      child: Row(
        children: <Widget>[

          Container(
            height: 85,
            width: 85,
            margin: EdgeInsets.only(right: 4),
            child: Stack(
              children: <Widget>[
                
                Container(
                  height: 85,
                  width: 85,
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(
                    value: .35,
                    backgroundColor: CupertinoColors.lightBackgroundGray,
                    valueColor: AlwaysStoppedAnimation<Color>(CupertinoColors.activeBlue),  
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Text(
                        '350',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Lato',
                          color: CupertinoColors.activeBlue,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                        '/1000',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Lato',
                        ),
                      ),

                    ],
                  ),
                ),
                
                
              ]
            )
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(
                  'Nivel 1',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Lato',
                    color: CupertinoColors.activeBlue,
                  ),
                ),

                Text(
                  'Alcanzá el nivel 2 sumando 650 puntos más.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Lato',
                  ),
                ),
                
              ],
            )
          )

        ],
      ),
    )
  );
}

Widget challengeCard(
  double screenWidth, 
  String title, 
  String description, 
  int points, 
  String actionBtn, 
  bool isCompleted,
  double progress
){
  return Container(
    width: screenWidth * .85,
    child: Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Row(
              children: <Widget>[

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Lato'
                    ),
                  ),
                ),

                Text(
                  '+$points',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? CupertinoColors.activeGreen: CupertinoColors.activeBlue,
                  ),
                ),
                
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: isCompleted ? 
                LinearProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation<Color>(CupertinoColors.activeGreen),
                ) : 
                LinearProgressIndicator(value: progress)
            ),
            
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Lato'
              ),
            ),

            Center(
              child: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  actionBtn,
                  style: TextStyle(
                    color: isCompleted ? CupertinoColors.activeGreen : CupertinoColors.activeBlue,
                  ),
                ), 
                onPressed: (){}
              ),
            )

          ],
        ),
      ),
    )
  );
}
