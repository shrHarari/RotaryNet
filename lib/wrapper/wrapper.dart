import 'package:flutter/material.dart';
import 'package:rotary_net/objects/arg_data_objects.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/screens/login_state_message_screen.dart';
import 'package:rotary_net/screens/registration_screen.dart';
import 'package:rotary_net/screens/rotary_main_screen.dart';
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
  final UserService personCardService = UserService();
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

    userObj = await personCardService.readUserObjectDataFromSharedPreferences();
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
                  return RegistrationScreen();
                  break;
                case Constants.LoginStatusEnum.Waiting:
                  return LoginStateMessageScreen(argDataObject: argDataObject);
                  break;
                case Constants.LoginStatusEnum.Accepted:
                /// If RequestStatus = "Accepted" => Display Gates List
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
