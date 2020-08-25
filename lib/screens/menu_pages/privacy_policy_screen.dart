import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.blue[700],
          elevation: 0.0,
          title: Text('Rotary Privacy Policy'),
        ),
        body: Center(
          child: Container(
            color: Colors.blue[100],
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0,),
                Text(
                  'Privacy Policy Screen',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 20.0),
                ),
              ],
            ),
          ),
        )
    );
  }
}
