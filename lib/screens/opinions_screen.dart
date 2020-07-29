import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:letter/models/user.dart';
import 'package:provider/provider.dart';

class OpinionsScreen extends StatefulWidget {
  final String name, uid;
  const OpinionsScreen({Key key, this.name, this.uid}) : super(key: key);
  @override
  _OpinionsScreenState createState() => _OpinionsScreenState();
}

class _OpinionsScreenState extends State<OpinionsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<User>(context, listen: false).getOpinions(widget.uid);
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Opiniones'),
      ),
      child: SafeArea(
        child: Container(
          color: CupertinoColors.extraLightBackgroundGray,
          child: Consumer<User>(
            builder: (context, user, child) {
              return ListView.builder(
                itemCount: user.opinions.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if(i == 0){
                    if(widget.uid == user.data.uid){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Text(
                          'Esto es lo que opinan los usuarios de ti:',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            color: CupertinoColors.black,
                          ),
                        )
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lato',
                            color: CupertinoColors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Estas son algunas opiniones que hicieron otros usuarios sobre '),
                            TextSpan(text: '${widget.name}', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ':'),
                          ],
                        ),
                      ),
                    );
                  }
                  Color opinionColor = CupertinoColors.destructiveRed;
                  switch (user.opinions[i-1]['type']) {
                    case 1:
                      opinionColor = CupertinoColors.systemYellow;
                      break;
                    case 2:
                      opinionColor = CupertinoColors.activeGreen;
                      break;
                    default:
                  }
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.opinions[i-1]['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Container(
                                height: 10,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: opinionColor
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0,7,0,5),
                            child: Text(
                              user.opinions[i-1]['opinion'],
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Lato'
                              ),
                            ),
                          ),

                          Text(
                            user.opinions[i-1]['date'],
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Lato'
                            ),
                          ),

                        ],
                      ),
                    )
                  );
                }
              );
            }
          ),
        )
      )
    );
  }
}