import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letter/models/user.dart';
import 'package:letter/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetLocationScreen extends StatefulWidget {
  @override
  _GetLocationScreenState createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image(image: AssetImage('assets/img/location.png')),
                  ),

                  Text(
                    'Ya casi terminamos',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Lato',
                      fontWeight: FontWeight.w300
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 60),
                    child: Text(
                      'Permítenos conocer tu ubicación para buscar personas cercanas a ti.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ),

                  CupertinoButton(
                    color: CupertinoColors.activeBlue,
                    child: Text('Mostrar mi ubicación'), 
                    onPressed: () async {
                      try {
                        Position position = await Geolocator()
                        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

                        setState(() => loading = true);

                        Provider.of<User>(context, listen: false).addLocation({
                          'lat': position.latitude,
                          'lon': position.longitude,
                        });
                      } catch (PlatformException) {}
                    }
                  )

                ],
              ),
            ),
          ),

          Loader(loading)

        ],
      ),
    );
  }
}