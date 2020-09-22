import 'dart:async';
import 'package:http/http.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  //#region User Login Confirm At SERVER [POST]
  // ===============================================================
  Future<ConnectedUserObject> userLoginConfirmAtServer(ConnectedUserObject aConnectedUserObj) async {
    try {
      ConnectedUserObject currentUserObj;

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        // Create UserObject to send to Server to confirm User Login
        dynamic result = await RotaryDataBaseProvider.rotaryDB
            .getUserByEmailAndPassword(aConnectedUserObj.email, aConnectedUserObj.password);

        if (result != null) {
          currentUserObj = result;
          return currentUserObj;
        }
        else
          return null;
      }
      //***** for debug *****

      // Convert UserObject To Json
      final jsonToPost = aConnectedUserObj.userToJson(aConnectedUserObj);
      // Check If User Login Parameters are OK !!!
      Response response = await post(Constants.rotaryUserLoginUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        String checkResult = jsonResponse;
        if (int.parse(checkResult) > 0)
        {
          await LoggerService.log('<RegistrationService> User Login Confirm At SERVER >>> OK\nHeader: $contentType \nUserRequestID: $checkResult');
          // Return full UserObject (with User Name)
          // currentUserObj.setRequestId(checkResult); // ===>>> if Login Check OK
          return currentUserObj;
        } else {
          await LoggerService.log('<RegistrationService> User Login Confirm At SERVER >>> Failed: Unable to get UserRequestID: $checkResult');
          print('<RegistrationService> User Login Confirm At SERVER >>> Failed: Unable to get UserRequestID: $checkResult');
          // Return Empty UserObject (without User Name)
          currentUserObj = aConnectedUserObj;
          // currentUserObj.setRequestId('-9');  // ===>>> if Login Check Failed
          return currentUserObj;
        }
      } else {
        await LoggerService.log('<LoginService> User Login Confirm At SERVER >>> Failed: Could not Login >>> ${response.statusCode}');
        print('<LoginService> User Login Confirm At SERVER Failed >>> Could not Login >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<LoginService> User Login Confirm At SERVER >>> Server ERROR: ${e.toString()}');
      developer.log(
        'userLoginConfirmAtServer',
        name: 'LoginService',
        error: 'User Request >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Login Object ==>> Secure Storage

  //#region Read Login Object Data From Secure Storage [ReadFromSS]
  //=============================================================================
  static Future<LoginObject> readLoginObjectDataFromSecureStorage() async {
    Constants.LoginStatusEnum _loginStatus;

    try{
      final secureStorage = new FlutterSecureStorage();

      _loginStatus = EnumToString.fromString(Constants.LoginStatusEnum.values, await secureStorage.read(key: Constants.rotaryLoginStatus));

      print('LoginService/Read >>> LoginStatus: $_loginStatus');

      return createLoginAsObject(_loginStatus);
    }
    catch  (e) {
      await LoggerService.log('<LoginService> Read Login Object Data From SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'readLoginObjectDataFromSecureStorage',
        name: 'LoginService',
        error: 'Read Login Object Data From SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write Login Object Data To Secure Storage [WriteToSS]
  //=============================================================================
  static Future writeLoginObjectDataToSecureStorage(Constants.LoginStatusEnum aLoginStatus) async {
    try{
      final secureStorage = new FlutterSecureStorage();

      await secureStorage.write(key: Constants.rotaryLoginStatus, value: EnumToString.parse(aLoginStatus));
    }
    catch  (e) {
      await LoggerService.log('<LoginService> Write Login Object Data To SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'writeLoginObjectDataToSecureStorage',
        name: 'LoginService',
        error: 'Write Login Object Data To SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Clear Login Object Data From Secure Storage
  //=============================================================================
  static Future clearLoginObjectDataFromSecureStorage() async {
    try {
      final secureStorage = new FlutterSecureStorage();
      await secureStorage.delete(key: Constants.rotaryLoginStatus);
    }
    catch (e){
      await LoggerService.log('<LoginService> Clear Login Object Data From SecureStorage >>> ERROR: ${e.toString()}');
      developer.log(
        'clearLoginObjectDataFromSecureStorage',
        name: 'LoginService',
        error: 'Clear Login Object Data From SecureStorage >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#endregion

}
