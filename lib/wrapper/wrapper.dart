import 'package:flutter/material.dart';
import 'package:rotary_net/objects/connected_user_global.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_state_message_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
import 'package:rotary_net/services/connected_user_service.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/services/user_service.dart';
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

  Future<LoginObject> loginObjForBuild;
  final UserService userService = UserService();
  final ConnectedUserService connectedUserService = ConnectedUserService();
  final RegistrationService registrationService = RegistrationService();
  bool loading = true;

  LoginObject currentLoginObj;
  ConnectedUserObject currentConnectedUserObj;

  @override
  void initState() {
    loginObjForBuild = setApplicationPhase();
    // checkRotaryDataBase();
    super.initState();
  }

  // Future<void> checkRotaryDataBase() async {
  //   print('>>>>>>>>>> usersList: Start');
  //   List<UserObject> usersList = await InitRotaryDataBase.rotaryDB.getAllUsers();
  //   if (usersList.isNotEmpty)
  //         print('>>>>>>>>>> usersList: ${usersList[0].emailId}');
  //
  //
  //   print('>>>>>>>>>> personCardsList: Start');
  //   List<PersonCardObject> personCardsList = await InitRotaryDataBase.rotaryDB.getAllPersonCards();
  //   if (personCardsList.isNotEmpty)
  //     print('>>>>>>>>>> personCardsList: ${personCardsList[0].emailId}');
  // }

  Future initializeGlobalValues() async {
    await LoggerService.initializeLogging();
    await LoggerService.log('<${this.runtimeType}> Logger was initiated');

    bool debugMode = await GlobalsService.getDebugMode();
    await GlobalsService.setDebugMode(debugMode);
  }

  Future<LoginObject> setApplicationPhase() async {
    LoginObject _loginObject;

    await initializeGlobalValues();

    setState(() {
      loading = true;
    });

    currentConnectedUserObj = await connectedUserService.readConnectedUserObjectDataFromSecureStorage();
    var userGlobal = ConnectedUserGlobal();
    userGlobal.setConnectedUserObject(currentConnectedUserObj);

    _loginObject = await LoginService.readLoginObjectDataFromSecureStorage();
    await LoginService.setLogin(_loginObject);
    print('Wrapper / loginObject: ${_loginObject.loginStatus}');

    await LoggerService.log('<${this.runtimeType}> Set Application Phase >>> Login State: ${LoginService.loginObject.loginStatus}');

    if (LoginService.loginObject.loginStatus != Constants.LoginStatusEnum.NoRequest)
    {
      /// Check Login Status {NoRequest, Waiting, Accepted, Rejected, NoStatus}
      /// LoginStatus >>> Switch Cases in Build Widget
      _loginObject = await registrationService.getRequestStatusFromServer(currentConnectedUserObj, _loginObject);
    }
    setState(() {
      loading = false;
    });
    return _loginObject;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginObject>(
        future: loginObjForBuild,
        builder: (context, snapshot) {
          if (snapshot.hasData)
            currentLoginObj = snapshot.data;

          return Scaffold(
            body:
            (snapshot.connectionState == ConnectionState.waiting)
            ? Loading()
            : (snapshot.hasError)

              ? DisplayErrorTextAndRetryButton(
                  errorText: 'שגיאה בשליפת אירועים',
                  buttonText: 'אנא פנה למנהל המערכת',
                  onPressed: () {},)

              : (snapshot.hasData)
                ? Container(
                      child: getPageByLoginStatus(currentLoginObj, currentConnectedUserObj),
                  )

                : Center(child: Text('אין תוצאות')),
          );
        }
      );
    }

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
}
