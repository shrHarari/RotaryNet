import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/shared/user_type_labled_radio.dart';

class DebugSettings extends StatefulWidget {
  static const routeName = '/DebugSettings';
  final LoginObject argLoginObject;

  DebugSettings({Key key, @required this.argLoginObject}) : super(key: key);

  @override
  _DebugSettings createState() => _DebugSettings();
}

class _DebugSettings extends State<DebugSettings> {

  ConnectedUserObject currentConnectedUserObj;
  String appBarTitle = 'Rotary Net';
  String iconBarTitle = 'Exit';
  bool isNoRequestStatus = false;
  bool newIsDebugMode;
  bool isFirst = true;
  Constants.UserTypeEnum userType;

  final ConnectedUserService connectedUserService = ConnectedUserService();
  String newLoginStatus = '';

  @override
  void initState() {
    getConnectedUserObject().then((value) {
      setState(() {
        currentConnectedUserObj = value;
        setCurrentLoginState();
        setCurrentUserType();
      });
    });
    super.initState();
  }

  Future<ConnectedUserObject> getConnectedUserObject() async {
    var _userGlobal = ConnectedUserGlobal();
    ConnectedUserObject _connectedUserObj = _userGlobal.getConnectedUserObject();
    return _connectedUserObj;
  }

  void setCurrentLoginState() async {
    if (widget.argLoginObject == null) isNoRequestStatus = true;
  }

  void setCurrentUserType() async {
    if (currentConnectedUserObj.userType == null)
      userType = Constants.UserTypeEnum.SystemAdmin;
    else
      userType = currentConnectedUserObj.userType;
  }

  Future updateLoginPhase(String aLoginStatus) async {
    Constants.LoginStatusEnum loginStatus;
    loginStatus = EnumToString.fromString(Constants.LoginStatusEnum.values, aLoginStatus);
    await LoginService.writeLoginObjectDataToSecureStorage(loginStatus);
    exitFromApp();
  }

  Future updateUserType(Constants.UserTypeEnum aUserType) async {
    await currentConnectedUserObj.setUserType(aUserType);
    await connectedUserService.writeConnectedUserTypeToSecureStorage(aUserType);
  }

  void updateDebugModeFunc(bool aIsDebug) {
    GlobalsService.setDebugMode(aIsDebug);
    GlobalsService.writeDebugModeToSP(aIsDebug);
  }

  Future startAllOver() async {
    /// LoginStatus='NoRequest' ==>>> Clear all data from SecureStorage
    await connectedUserService.clearConnectedUserObjectDataFromSecureStorage();
    await LoginService.clearLoginObjectDataFromSecureStorage();
    exitFromApp();
  }

  Future waitingToAcceptUserRegistration() async {
    newLoginStatus = 'Waiting';         /// ==>>> Waiting to PersonCard Confirmation [MessagePersonCardRequest]
    updateLoginPhase(newLoginStatus);
  }

  Future acceptUserRegistration() async {
    newLoginStatus = 'Accepted';        /// ==>>> Register PersonCard Accepted [DisplayRotaryMainScreen]
    updateLoginPhase(newLoginStatus);
  }

  void exitFromApp() {
    exit(0);
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
                      await waitingToAcceptUserRegistration();
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
                      await acceptUserRegistration();
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
                          updateDebugModeFunc(newValue);
                          setState(() {
                            newIsDebugMode = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Text(
                        'User Type:',
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 16.0),
                      ),
                    ),

                    Expanded(
                      flex: 8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <UserTypeLabeledRadio>[
                          UserTypeLabeledRadio(
                            label: 'System Admin',
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            value: Constants.UserTypeEnum.SystemAdmin,
                            groupValue: userType,
                            onChanged: (Constants.UserTypeEnum newValue) {
                              setState(() {
                                userType = newValue;
                              });
                              updateUserType(userType);
                            },
                          ),
                          UserTypeLabeledRadio(
                            label: 'Rotary Member',
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            value: Constants.UserTypeEnum.RotaryMember,
                            groupValue: userType,
                            onChanged: (Constants.UserTypeEnum newValue) {
                              setState(() {
                                userType = newValue;
                              });
                              updateUserType(userType);
                            },
                          ),
                          UserTypeLabeledRadio(
                            label: 'Guest',
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            value: Constants.UserTypeEnum.Guest,
                            groupValue: userType,
                            onChanged: (Constants.UserTypeEnum newValue) {
                              setState(() {
                                userType = newValue;
                              });
                              updateUserType(userType);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),

                RaisedButton(
                    elevation: 0.0,
                    disabledElevation: 0.0,
                    color: Colors.blue,
                    child: Text(
                      'Initialize Rotary Database',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await RotaryDataBaseProvider.rotaryDB.createRotaryDB();

                      await RotaryDataBaseProvider.rotaryDB.insertAllStartedUsersToDb();
                      await RotaryDataBaseProvider.rotaryDB.insertAllStartedPersonCardsToDb();
                      await RotaryDataBaseProvider.rotaryDB.insertAllStartedEventsToDb();
                    }
                ),
                SizedBox(height: 20.0,),

                RaisedButton(
                    elevation: 0.0,
                    disabledElevation: 0.0,
                    color: Colors.red,
                    child: Text(
                      'Delete Rotary Database',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      await RotaryDataBaseProvider.rotaryDB.deleteRotaryDatabase();
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
