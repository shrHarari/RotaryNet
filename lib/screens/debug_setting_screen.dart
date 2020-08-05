import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;

class DebugSettings extends StatefulWidget {
  static const routeName = '/DebugSettings';
  final ArgDataObject argDataObject;

  DebugSettings({Key key, @required this.argDataObject}) : super(key: key);

  @override
  _DebugSettings createState() => _DebugSettings();
}

class _DebugSettings extends State<DebugSettings> {

  String appBarTitle = 'Rotary Net';
  String iconBarTitle = 'Exit';
  bool isNoRequestStatus = false;
  bool newIsDebugMode;
  bool isFirst = true;

  final UserService userService = UserService();
  String newLoginStatus = '';

  @override
  void initState() {
    setCurrentLoginState();
    super.initState();
  }

  void setCurrentLoginState() async {
    if (widget.argDataObject.passLoginObj == null) isNoRequestStatus = true;
  }

  Future updateLoginPhase(String aLoginStatus) async {
    Constants.LoginStatusEnum loginStatus;
    loginStatus = EnumToString.fromString(Constants.LoginStatusEnum.values, aLoginStatus);
    await LoginService.writeLoginObjectDataToSharedPreferences(loginStatus);
    exitFromApp();
  }

  Future startAllOver() async {
    /// LoginStatus='NoRequest' ==>>> Clear all data from SharedPreferences
    await userService.clearUserObjectDataFromSharedPreferences();
    await LoginService.clearLoginObjectDataFromSharedPreferences();
    exitFromApp();
  }

  Future waitingToAcceptPersonCardRegistration() async {
    newLoginStatus = 'Waiting';         /// ==>>> Waiting to PersonCard Confirmation [MessagePersonCardRequest]
    updateLoginPhase(newLoginStatus);
  }

  Future acceptPersonCardRegistration() async {
    newLoginStatus = 'Accepted';        /// ==>>> Register PersonCard Accepted [DisplayRotaryMainScreen]
    updateLoginPhase(newLoginStatus);
  }

  void exitFromApp() {
    exit(0);
  }

  void debugModeFunc(bool aIsDebug) {
    GlobalsService.setDebugMode(aIsDebug);
    GlobalsService.writeDebugModeToSP(aIsDebug);
  }

  @override
  Widget build(BuildContext context) {

    // Initial Value
    if (isFirst){
      newIsDebugMode = GlobalsService.isDebugMode;
      isFirst = false;
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[500],
        elevation: 5.0,
        title: Text(appBarTitle),
        actions: <Widget>[
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

      body: Center(
        child: Container(
          child:
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 20.0),
                RaisedButton(
                    elevation: 0.0,
                    disabledElevation: 0.0,
                    color: Colors.green,
                    child: Text(
                      'Start All Over: No Request',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await startAllOver();
                    }
                ),

                SizedBox(height: 20.0),
                RaisedButton(
                    elevation: 0.0,
                    disabledElevation: 0.0,
                    color: Colors.green,
                    child: Text(
                      'Waiting To Accept User Registration',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: isNoRequestStatus ? null : () async {
                      await waitingToAcceptPersonCardRegistration();
                    }
                ),

                SizedBox(height: 20.0),
                RaisedButton(
                    elevation: 0.0,
                    disabledElevation: 0.0,
                    color: Colors.green,
                    child: Text(
                      'Accept User Registration',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: isNoRequestStatus ? null : () async {
                      await acceptPersonCardRegistration();
                    }
                ),


                ///============ Debug Mode SETTINGS ============
                SizedBox(height: 40.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Divider(
                        color: Colors.grey[600],
                        thickness: 2.0,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Text (
                        'Debug Mode',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Divider(
                        color: Colors.grey[600],
                        thickness: 2.0,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Text(
                        'Is Debug Mode ?:',
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 16.0),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Switch(
                        value: newIsDebugMode,
                        onChanged: (bool newValue) {
                          debugModeFunc(newValue);
                          setState(() {
                            newIsDebugMode = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

