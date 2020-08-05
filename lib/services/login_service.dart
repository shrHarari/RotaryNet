import 'dart:async';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class LoginService {
  static LoginObject loginObject;

  static Future setLogin(LoginObject aLoginObject) async {
    loginObject = aLoginObject;
  }

  //#region Create Login As Object
  //=============================================================================
  static LoginObject createLoginAsObject(Constants.LoginStatusEnum aLoginStatus)
  {
    if (aLoginStatus == null)
      return LoginObject(loginStatus: Constants.LoginStatusEnum.NoRequest);
    else
      return LoginObject(loginStatus: aLoginStatus);
  }
  //#endregion

  //#region Read Login Object Data From Shared Preferences [ReadFromSP]
  //=============================================================================
  static Future<LoginObject> readLoginObjectDataFromSharedPreferences() async {
    Constants.LoginStatusEnum loginStatus;

    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      loginStatus = EnumToString.fromString(Constants.LoginStatusEnum.values, prefs.getString(Constants.rotaryLoginStatus));
      print('LoginService/Read >>> LoginStatus: $loginStatus');

      return createLoginAsObject(loginStatus);
    }
    catch  (e) {
      await LoggerService.log('<LoginService> Read Login Object Data From SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'readLoginObjectDataFromSharedPreferences',
        name: 'LoginService',
        error: 'Read Login Object Data From SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Login Object Data To Shared Preferences [WriteToSP]
  //=============================================================================
  static Future writeLoginObjectDataToSharedPreferences(Constants.LoginStatusEnum aLoginStatus) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.rotaryLoginStatus, EnumToString.parse(aLoginStatus));
    }
    catch  (e) {
      await LoggerService.log('<LoginService> Write Login Object Data To SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'writeLoginObjectDataToSharedPreferences',
        name: 'LoginService',
        error: 'Write Login Object Data To SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Clear Login Object Data From Shared Preferences
  //=============================================================================
  static Future clearLoginObjectDataFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.rotaryLoginStatus);
    }
    catch (e){
      await LoggerService.log('<LoginService> Clear Login Object Data From SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'clearLoginObjectDataFromSharedPreferences',
        name: 'LoginService',
        error: 'Clear Login Object Data From SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion
}
