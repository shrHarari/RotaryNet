import 'dart:io';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/screens/debug_setting_screen.dart';
import 'package:rotary_net/shared/circle_button.dart';
import 'package:rotary_net/shared/loading.dart';

class LoginStateMessageScreen extends StatefulWidget {
  static const routeName = '/LoginStateMessageScreen';
  final ArgDataUserObject argDataObject;

  LoginStateMessageScreen({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _LoginStateMessageScreen createState() => _LoginStateMessageScreen();
}

class _LoginStateMessageScreen extends State<LoginStateMessageScreen> {

  String appBarTitle = 'Rotary / Request';
  String iconBarTitle = 'Exit';
  String sharedPreferencesData = '';
  String messageTitle = '';
  String messageBody = '';
  bool loading = true;
  bool isShowDataForDebug = false;

  @override
  void initState() {
    createDataToDisplay();
    super.initState();
  }

  Future<Null> createDataToDisplay() async {

    if (widget.argDataObject.passUserObj.email == null)
    {
      setState(() {
        sharedPreferencesData = 'Unable to read SharedPreferences';
        loading = false;
      });
    } else {
      setState(() {
        messageTitle = 'Dear ${widget.argDataObject.passUserObj.firstName} ${widget.argDataObject.passUserObj.lastName},';
        messageBody = 'Your Request is being Handle.\n\n'
            'We are doing our best to confirm\n'
            'your registration.\n\n'
            'Please wait up to 24 hours,\n'
            'and we will send you a confirmation mail';

        sharedPreferencesData = 'User Data To Display: \n'
            'User Request Id: ${widget.argDataObject.passUserObj.requestId}\n'
            'User Email: ${widget.argDataObject.passUserObj.email}\n'
            'User Name: ${widget.argDataObject.passUserObj.firstName} ${widget.argDataObject.passUserObj.lastName}\n'
            'User Password: ${widget.argDataObject.passUserObj.password}\n'
            'Login Status: ${EnumToString.parse(widget.argDataObject.passLoginObj.loginStatus)}';
        loading = false;
      });
    }
  }

  Future<void> openDebugSettings() async {
    // Navigate to DebugSettings Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DebugSettings(argDataObject: widget.argDataObject),
      ),
    );
  }

  void exitFromApp() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() :
    Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          backgroundColor: Colors.blue[500],
          elevation: 5.0,
          title: Text(appBarTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.build, color: Colors.white),
              onPressed: () async {await openDebugSettings();},
            ),
            FlatButton.icon(
                onPressed: () {
                  exitFromApp();
                },
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                label: Text(iconBarTitle,
                  style: TextStyle(color: Colors.white),
                )
            )
          ],
        ),

        body: buildMainScaffoldBody()
    );
  }

  Widget buildMainScaffoldBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.0),
            GestureDetector(
              child: Container(
                color: Colors.blue[50],
                child: Text('Login Request',
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              onDoubleTap: () {
                setState(() {
                  isShowDataForDebug = !isShowDataForDebug;
                });
              },
            ),

            SizedBox(height: 30.0,),
            Container(
              color: Colors.blue[50],
              child: Text(messageTitle,
                style: TextStyle(
                    color: Colors.blue[900],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20.0,),
            Container(
              color: Colors.blue[50],
              child: Center(
                child: Text(messageBody,
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 18.0),
                ),
              ),
            ),

            ///--------------------- Circle Button ---------------------
            SizedBox(height: 100.0,),
            CircleButton(
                buttonText: 'OK',
                backgroundButtonSize: 140.0,
                foregroundButtonSize: 120.0,
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                onTap: exitFromApp
            ),

            SizedBox(height: 30.0,),
            Visibility(
              visible: isShowDataForDebug,
              child: Container(
                color: Colors.white,
                child: Text(sharedPreferencesData,
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 14.0),
                ),
              ),
            ),
          ]
      ),
    );
  }
}

