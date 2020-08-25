import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'file:///C:/FLUTTER_OCTIA/rotary_net/lib/screens/wellcome_pages/login_state_message_screen.dart';
import 'package:rotary_net/screens/rotary_main_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/login_screen.dart';
import 'package:rotary_net/screens/wellcome_pages/register_screen.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/services/registration_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/error_message.dart';
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

  @override
  void initState() {
    loginObjForBuild = setApplicationPhase();
    super.initState();
  }

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
    return loading ? Loading() : Scaffold(
      body: FutureBuilder<LoginObject>(
          future: loginObjForBuild,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              LoginObject currentLoginObj = snapshot.data;

              switch (currentLoginObj.loginStatus) {
                case Constants.LoginStatusEnum.NoRequest:
                  return RegisterScreen(argDataObject: argDataObject);
                case Constants.LoginStatusEnum.Waiting:
                  return LoginStateMessageScreen(argDataObject: argDataObject);
                  break;
                case Constants.LoginStatusEnum.Accepted:
                  if ((argDataObject.passUserObj.stayConnected == null) || (!argDataObject.passUserObj.stayConnected))
                    return LoginScreen(argDataObject: argDataObject);
                  else
                    return RotaryMainScreen(argDataObject: argDataObject);
                  break;
                case Constants.LoginStatusEnum.NoStatus:
                  return ErrorMessage(
                      errTitle: 'Registration Message',
                      errMsg: 'NoStatus Phase'
                  );
                  break;
                case Constants.LoginStatusEnum.Rejected:
                  return ErrorMessage(
                      errTitle: 'Registration Message',
                      errMsg: 'Rejected Phase'
                  );
                  break;
                default:
                  return ErrorMessage(
                      errTitle: 'Registration Message',
                      errMsg: 'Default Phase'
                  );
                  break;
              }
            } else {
              if (snapshot.hasError) {
                print('Wrapper / Snapshot Error Message: ${snapshot.error}');
                return Text("${snapshot.error}", style: Theme.of(context).textTheme.headline);
              } else {
                print('Wrapper / Error Message: Unable to read User data');
                return Loading();
              }
            }
          }
      ),
    );
  }
}
