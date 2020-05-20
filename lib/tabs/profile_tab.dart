import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: CupertinoColors.extraLightBackgroundGray,
        child: Stack(
          children: <Widget>[

            Container(
              height: 170,
              padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [CupertinoColors.activeBlue, CupertinoColors.systemPurple]
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Text(
                        'Dinero ahorrado',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Lato',
                          color: CupertinoColors.white
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 50,
                            fontFamily: 'Lato',
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w300
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '\$', style: TextStyle(fontSize: 30)),
                            TextSpan(text: '1.850'),
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                          
                  Container(
                    height: 110,
                    width: 100,
                    child: Stack(
                      children: <Widget>[

                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage('https://lh3.googleusercontent.com/bneu37awjdXylrdUvoo-MNsvBweeuYgVJBqaLMy2sKSkWd_n21Pggp6GwexL6RLA8eLJWqJp9SkkoD6XTizHV2ZuXD6T5G1RWXaKrYkh6rBAqqjY9Hbsn_CStlQkpXLSbTWxVznGf2C0WFpvvEpX-tmvgy5BFeoBUtfu07KOdvpbBoqYjmKJJIskPMlUzCK59Zm1mYJu9MLGKOqWrkxyJakxdffI4TAZz0EmT15er_S8Dd9S3n7WaNNjE7YGJ0RVahLnLm6sUHkVqp-3iWQWcppokOvpoQ4Er7tt0wRFyOAmmuXsLVcXyww6Ks-W1OMPfLuUqsjrccH3eDR8SUGD2JdBqhGZgXrcvJN0xL18EvV3vJJQdnbnHKjIFEMpW87jEBUttoD8NCzv-jtOESAW-gxHgJJsD0IygMNXuw-XjcNsRmJguxBWHQ-I2aYJz6gl_KKQi7YhsxyvnvKwME9odFADa_JbNTWU1h2K1IAmCy7NRjD-Al-Y3ylUyi2DrShf7JwZrYp-eFecCrDhblhNby4akCY6UzTRJxTTydg95oa18jzMNWrlxVmYB8kOZ9AKcIh9RvcC0ZbPABEV8MJL3zZeXuf1DIp-W0cd6gEA7jSyzKNW8Xe48XxUDNa8e7EBMavTxpCofi9XQfrNduQlwc_k9YpnU3Ja0_IaEP_R_g4BtbX4t2HuXj3IWgEVe-i4h2lcmeuKRnQkhmukdIMOhHpmQA_14M40_H5Nsf8y0Lo1btM_eWo010k=s500-no'),
                          backgroundColor: Colors.transparent,
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Agustín',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Lato'
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(CupertinoIcons.check_mark_circled_solid, size: 18,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  )
                  
                ],
              ),
            ),
            
            ListView(
              padding: EdgeInsets.only(top: 170),
                children: <Widget>[

                  Container(
                    color: CupertinoColors.extraLightBackgroundGray,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Card(
                            margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Icon(CupertinoIcons.info, size: 30, color: CupertinoColors.activeOrange,),
                                  SizedBox(width: 8,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 4,),
                                        
                                        Text(
                                          'Completá tu perfil',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        Text(
                                          'Un perfil completo genera confianza en las personas.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Lato',
                                          ),
                                        ),

                                        SizedBox(height: 6,),
                                        LinearProgressIndicator(value: .25,),

                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: CupertinoButton(
                                            padding: EdgeInsets.all(0),
                                            child: Text('Completar perfil'), 
                                            onPressed: (){}
                                          )
                                        ),

                                      ],
                                    ),
                                  )
                                  
                                ],
                              ),
                            ),
                          ),

                          Card(
                            margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Icon(CupertinoIcons.check_mark_circled, size: 30, color: CupertinoColors.activeGreen,),
                                  SizedBox(width: 8,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 4,),
                                        
                                        Text(
                                          'Accediste a prestar "Cien años de soledad".',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        Text(
                                          'Coordiná un punto de encuentro con María.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Lato',
                                          ),
                                        ),

                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: CupertinoButton(
                                            padding: EdgeInsets.all(0),
                                            child: Text('Chatear con María'), 
                                            onPressed: (){}
                                          )
                                        ),

                                      ],
                                    ),
                                  )
                                  
                                ],
                              ),
                            ),
                          ),

                          Card(
                            margin: EdgeInsets.fromLTRB(12, 0, 12, 20),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 6, 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Icon(CupertinoIcons.book, size: 30),

                                  SizedBox(width: 8,),
                                  
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(height: 4,),
                                        
                                        Text(
                                          'Estás leyendo "Cien años de".',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),

                                        Text(
                                          'Vas por la página 225.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Lato',
                                          ),
                                        ),

                                        SizedBox(height: 6,),
                                        LinearProgressIndicator(value: .25,),

                                      ],
                                    ),
                                  ),
                                  
                                  Icon(CupertinoIcons.right_chevron, size: 30,),

                                ],
                              ),
                            ),
                          ),

                          Card(
                            margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[

                                  Icon(CupertinoIcons.settings, size: 30,),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(8, 2, 0, 0),
                                      child: Text(
                                        'Configuración',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ),
                                  ),

                                  Icon(CupertinoIcons.right_chevron, size: 30,),

                                ],
                              )
                            )
                          ),

                          SizedBox(height: 20,),

                          CupertinoButton(
                            child: Text(
                              'Cerrar sesión',
                              style: TextStyle(
                                color: CupertinoColors.destructiveRed
                              ),
                            ), 
                            onPressed: () => Provider.of<User>(context, listen: false).signOut()
                          )

                        ],
                      ),
                  ),
                  
                ],
              ),

          ],
        ),
      ),
    );
  }
}