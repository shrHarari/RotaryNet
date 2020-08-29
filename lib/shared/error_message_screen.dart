import 'package:flutter/material.dart';

class ErrorMessageScreen extends StatelessWidget {
  final String errTitle;
  final String errMsg;

  ErrorMessageScreen({this.errTitle, this.errMsg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
          title: Text('Rotary / $errTitle'),
        ),
        body: Center(
          child: Container(
            color: Colors.blue[100],
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.0,),
                Text(
                  '$errMsg',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0),
                  ),
                ],
              ),
          ),
        )
    );
  }
}

class DisplayNoDataErrorText extends StatelessWidget {
  const DisplayNoDataErrorText({Key key, this.errorText}) : super(key: key);
  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorText,
            style: Theme.of(context).textTheme.headline,
          ),
        ],
      ),
    );
  }
}