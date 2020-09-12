import 'package:flutter/material.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/person_card_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/rotary_main_pages/rotary_main_page_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_state_message_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
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
  final RegistrationService registrationService = RegistrationService();
  ArgDataUserObject argDataObject;
  bool loading = true;

  LoginObject currentLoginObj;

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
    UserObject userObj;
    LoginObject loginObject;

    await initializeGlobalValues();

    setState(() {
      loading = true;
    });

    userObj = await userService.readUserObjectDataFromSharedPreferences();

    loginObject = await LoginService.readLoginObjectDataFromSharedPreferences();
    print('readLoginObjectDataFromSharedPreferences: ${loginObject.loginStatus}');
    await LoginService.setLogin(loginObject);

    argDataObject = ArgDataUserObject(userObj, loginObject);

    await LoggerService.log('<${this.runtimeType}> Set Application Phase >>> Login State: ${LoginService.loginObject.loginStatus}');

    if (LoginService.loginObject.loginStatus != Constants.LoginStatusEnum.NoRequest)
    {
      /// Check Login Status {NoRequest, Waiting, Accepted, Rejected, NoStatus}
      /// LoginStatus >>> Switch Cases in Build Widget
      print('loginObject: ${loginObject.loginStatus}');
      loginObject = await registrationService.getRequestStatusFromServer(userObj, loginObject);
    }
    setState(() {
      loading = false;
    });
    return loginObject;
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
                      child: getPageByLoginStatus(currentLoginObj, argDataObject),
                  )

                : Center(child: Text('אין תוצאות')),
          );
        }
      );
    }

  Widget getPageByLoginStatus(LoginObject aLoginObj, ArgDataUserObject aDataObject) {
    switch (aLoginObj.loginStatus) {
      case Constants.LoginStatusEnum.NoRequest:
        return RegisterScreen(argDataObject: aDataObject);
      case Constants.LoginStatusEnum.Waiting:
        return LoginStateMessageScreen(argDataObject: aDataObject);
        break;
      case Constants.LoginStatusEnum.Accepted:
        if ((aDataObject.passUserObj.stayConnected == null) || (!aDataObject.passUserObj.stayConnected))
          return LoginScreen(argDataObject: aDataObject);
        else
          return RotaryMainPageScreen(argDataObject: aDataObject);
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
