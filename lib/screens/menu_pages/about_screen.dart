import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:rotary_net/services/menu_pages_service.dart';

class AboutScreen extends StatefulWidget {
  static const routeName = '/AboutScreen';

  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  final TextEditingController aboutTextController = TextEditingController();
  String aboutText ="";

  @override
  void initState() {
    getAboutDisplayText().then((String aText)
    {
      setState(() {
        aboutText = aText;
      });
    });

    super.initState();
  }

  Future<String> getAboutDisplayText() async {
    MenuPagesService menuPagesService = MenuPagesService();
    dynamic aText = await menuPagesService.getAboutDisplayTextFromServer();

    return aText.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            Container(
              height: 120,
              color: Colors.lightBlue[400],
              child: SafeArea(
                  child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'אודות',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                        ),

                        /// Menu Icon
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10.0, 10.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close, color: Colors.white, size: 30.0,),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ]
                  )
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 50.0),
                child: Text(
                  aboutText,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      fontFamily: 'Heebo-Light',
                      fontSize: 17.0,
                      height: 1.5,
                      color: Colors.black87
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
}
