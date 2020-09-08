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

  String appBarTitle = 'רוטרי / אישור בקשה';
  String iconBarTitle = 'יציאה';
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

    if (widget.argDataObject.passUserObj.emailId == null)
    {
      setState(() {
        sharedPreferencesData = 'שגיאה ברישום נתונים';
        loading = false;
      });
    } else {
      setState(() {
        messageTitle = 'שלום ${widget.argDataObject.passUserObj.firstName} ${widget.argDataObject.passUserObj.lastName},';
        messageBody = 'מנהלי המערכת מטפלים בבקשתך.\n\n'
            'אנא המתן ואנו נשלח אליך מייל לאישור בקשתך\n';

        sharedPreferencesData = 'User Data To Display: \n'
            // 'User Request Id: ${widget.argDataObject.passUserObj.requestId}\n'
            'User EmailId: ${widget.argDataObject.passUserObj.emailId}\n'
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
          backgroundColor: Colors.lightBlue[500],
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Center(
                    child: Container(
                      color: Colors.blue[50],
                      child: Text(messageTitle,
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                onDoubleTap: () {
                  setState(() {
                    isShowDataForDebug = !isShowDataForDebug;
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.only(top: 60, left: 30.0, right: 30.0),
                child: Center(
                  child: Container(
                    color: Colors.blue[50],
                    child: Text(messageBody,
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 18.0),
                    ),
                  ),
                ),
              ),

              ///--------------------- Circle Button ---------------------
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: CircleButton(
                    buttonText: 'OK',
                    backgroundButtonSize: 140.0,
                    foregroundButtonSize: 120.0,
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    onTap: exitFromApp
                ),
              ),

              Visibility(
                visible: isShowDataForDebug,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    color: Colors.white,
                    child: Text(
                      sharedPreferencesData,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}

