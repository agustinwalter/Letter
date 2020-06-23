import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
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
              child: SafeArea(
                child: ConditionalSwitch.single<int>(
                  context: context,
                  valueBuilder: (BuildContext context) => index,
                  caseBuilders: {
                    0: (BuildContext context) => LendBooksTab(),
                    1: (BuildContext context) => WishList(),
                    2: (BuildContext context) => ProfileTab(),
                  },
                  fallbackBuilder: (BuildContext context) => LendBooksTab()
                )
              )
            );
          },
        );
      }
    );
  }
}