import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letter/screens/create_wish_list_screen.dart';
import 'package:letter/screens/get_location_screen.dart';
import 'package:letter/screens/logged_screen.dart';
import 'package:letter/screens/loginScreen.dart';
import 'package:letter/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(
      ChangeNotifierProvider(create: (context) => User(), child: Letter()));
}

class Letter extends StatefulWidget {
  @override
  _LetterState createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).initUser();
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<User>(context, listen: false).endApp();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          Consumer<User>(
            builder: (context, user, child) {
              if (user.isLoading) return Loader(true);
              if (user.data == null) return LoginScreen();
              if (user.dataV == null) return CreateWishListScreen();
              if (user.dataV['wishList'] == null) return CreateWishListScreen();
              if (user.dataV['location'] == null) return GetLocationScreen();
              return LoggedScreen();
            },
          ),
        ],
      ),
    );
  }
}
