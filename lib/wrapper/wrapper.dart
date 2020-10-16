import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_state_message_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/services/registration_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/error_message_screen.dart';
import 'package:rotary_net/shared/loading.dart';

class Wrapper extends StatefulWidget {
  static const routeName = '/Wrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  final ConnectedUserService connectedUserService = ConnectedUserService();
  final RegistrationService registrationService = RegistrationService();

  Future<DataRequiredForBuild> dataRequiredForBuild;
  DataRequiredForBuild currentDataRequired;
  bool loading = true;

  @override
  void initState() {
    dataRequiredForBuild = getAllRequiredDataForBuild();
    super.initState();
  }

  //#region Get All Required Data For Build
  Future<DataRequiredForBuild> getAllRequiredDataForBuild() async {
    setState(() {
      loading = true;
    });
    bool _debugMode = await initializeGlobalValues();
    ConnectedUserObject _connectedUserObj = await initializeConnectedUserObject();
    LoginObject _loginObject = await initializeLoginObject(_connectedUserObj);

    setState(() {
      loading = false;
    });

    return DataRequiredForBuild(
      debugMode: _debugMode,
      connectedUserObj: _connectedUserObj,
      loginObject: _loginObject,
    );
  }
  //#endregion

  //#region Initialize Global Values
  Future <bool> initializeGlobalValues() async {
    await LoggerService.initializeLogging();
    await LoggerService.log('<${this.runtimeType}> Logger was initiated');

    bool _debugMode = await GlobalsService.getDebugMode();
    await GlobalsService.setDebugMode(_debugMode);

    return _debugMode;
  }
  //#endregion

  //#region Initialize Connected UserObject
  Future <ConnectedUserObject> initializeConnectedUserObject() async {
    ConnectedUserObject _currentConnectedUserObj = await connectedUserService.readConnectedUserObjectDataFromSecureStorage();
    print('Wrapper / _currentConnectedUserObj: $_currentConnectedUserObj');
    var userGlobal = ConnectedUserGlobal();
    userGlobal.setConnectedUserObject(_currentConnectedUserObj);

    return _currentConnectedUserObj;
  }
  //#endregion

  //#region Initialize Connected LoginObject
  Future <LoginObject> initializeLoginObject(ConnectedUserObject aConnectedUserObj) async {
    LoginObject _loginObject = await LoginService.readLoginObjectDataFromSecureStorage();
    await LoginService.setLogin(_loginObject);
    print('Wrapper / loginObject: ${_loginObject.loginStatus}');

    await LoggerService.log('<${this.runtimeType}> Set Application Phase >>> Login State: ${LoginService.loginObject.loginStatus}');
    if (LoginService.loginObject.loginStatus != Constants.LoginStatusEnum.NoRequest)
    {
      /// Check Login Status {NoRequest, Waiting, Accepted, Rejected, NoStatus}
      /// LoginStatus >>> Switch Cases in Build Widget
      _loginObject = await registrationService.getRequestStatusFromServer(aConnectedUserObj, _loginObject);
    }
    return _loginObject;
  }
  //#endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DataRequiredForBuild>(
        future: dataRequiredForBuild,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Loading();
          else
            if (snapshot.hasError) {
              return DisplayErrorTextAndRetryButton(
                        errorText: 'שגיאה בשליפת אירועים',
                        buttonText: 'אנא פנה למנהל המערכת',
                        onPressed: () {},
              );
            } else {
              if (snapshot.hasData)
              {
                currentDataRequired = snapshot.data;
                return getPageByLoginStatus(
                    currentDataRequired.loginObject,
                    currentDataRequired.connectedUserObj);
              }
              else
                return Center(child: Text('אין תוצאות'));
            }
        }
      ),
    );
  }

  //#region Get Page By Login Status
  Widget getPageByLoginStatus(LoginObject aLoginObj, ConnectedUserObject aConnectedUserObject) {
    switch (aLoginObj.loginStatus) {
      case Constants.LoginStatusEnum.NoRequest:
        return RegisterScreen(argLoginObject: aLoginObj);
        break;
      case Constants.LoginStatusEnum.Waiting:
        return LoginStateMessageScreen(argConnectedUserObject: aConnectedUserObject, argLoginObject: aLoginObj);
        break;
      case Constants.LoginStatusEnum.Accepted:
        if ((aConnectedUserObject.stayConnected == null) || (!aConnectedUserObject.stayConnected))
          return LoginScreen(argLoginObject: aLoginObj);
        else
          return RotaryMainPageScreen(argLoginObject: aLoginObj);
        break;
      case Constants.LoginStatusEnum.NoStatus:
        return RotaryErrorMessageScreen(
            errTitle: 'Registration Message',
            errMsg: 'NoStatus Phase'
        );
        break;
      case Constants.LoginStatusEnum.Rejected:
        return RotaryErrorMessageScreen(
            errTitle: 'Registration Message',
            errMsg: 'Rejected Phase'
        );
        break;
      default:
        return RotaryErrorMessageScreen(
            errTitle: 'Registration Message',
            errMsg: 'Default Phase'
        );
        break;
    }
  }
  //#endregion
}

class DataRequiredForBuild {
  ConnectedUserObject connectedUserObj;
  LoginObject loginObject;
  bool debugMode;

  DataRequiredForBuild({
    this.connectedUserObj,
    this.loginObject,
    this.debugMode,
  });
}
