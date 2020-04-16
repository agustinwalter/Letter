import 'package:flutter/material.dart';
import 'package:letter/models/book_model.dart';
import 'package:letter/models/user_model.dart';
import 'package:letter/screens/books_screen.dart';
import 'package:letter/screens/profile_screen.dart';
import 'package:letter/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => UserModel()),
        ChangeNotifierProvider(builder: (context) => BookModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Letter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    BooksScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];
  
  onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  void initState() {
    super.initState();
    () async {
      await Future.delayed(Duration.zero);
      Provider.of<UserModel>(context, listen: false).initUser();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, 
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            title: Text('Libros'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Buscar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil')
          ),
        ],
      )
    );
  }
}
