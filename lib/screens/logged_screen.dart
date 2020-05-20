import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:letter/tabs/challenges_tab.dart';
import 'package:letter/tabs/lend_books_tab.dart';
import 'package:letter/tabs/profile_tab.dart';
import 'package:letter/tabs/wish_list.dart';

class LoggedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        iconSize: 30,
        items: <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.book), 
            title: Text(
              'Prestar libros',
              style: TextStyle(fontSize: 13),
            )
          ),

          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.flag), 
            title: Text(
              'Objetivos',
              style: TextStyle(fontSize: 13),
            )
          ),
          
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart), 
            title: Text(
              'Deseos',
              style: TextStyle(fontSize: 13),
            )
          ),
          
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person), 
            title: Text(
              'Perfil',
              style: TextStyle(fontSize: 13),
            )
          ),

        ]
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context){
            return CupertinoPageScaffold(
              // navigationBar: CupertinoNavigationBar(
              //   middle: ConditionalSwitch.single<int>(
              //     context: context,
              //     valueBuilder: (BuildContext context) => index,
              //     caseBuilders: {
              //       0: (BuildContext context) => Text('Prestar libros'),
              //       1: (BuildContext context) => Text('Objetivos'),
              //       2: (BuildContext context) => Text('Lista de deseos'),
              //       3: (BuildContext context) => Text('Perfil'),
              //     },
              //     fallbackBuilder: (BuildContext context) => Text('Objetivos')
              //   )
              // ),
              child: SafeArea(
                child: ConditionalSwitch.single<int>(
                  context: context,
                  valueBuilder: (BuildContext context) => index,
                  caseBuilders: {
                    0: (BuildContext context) => LendBooksTab(),
                    1: (BuildContext context) => ChallengesTab(),
                    2: (BuildContext context) => WishList(),
                    3: (BuildContext context) => ProfileTab(),
                  },
                  fallbackBuilder: (BuildContext context) => ChallengesTab()
                )
              )
            );
          },
        );
      }
    );
  }
}