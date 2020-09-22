import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/database/rotary_database_provider.dart';
import 'package:rotary_net/objects/connected_user_object.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class RegistrationService {

  //#region Get Request Status From Server [GET]
  // =========================================================
  Future<LoginObject> getRequestStatusFromServer(ConnectedUserObject aConnectedUserObj, LoginObject aLoginObject ) async {
    try {
      LoginObject newLoginObject = aLoginObject;

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        return newLoginObject;
      }
      //***** for debug *****

      /// StatusUrl: 'http://159.89.225.231:7775/api/registration/isregistered/requestId={requestId}'
      String requestStatusUrl = '${Constants.rotaryUserRegistrationUrl}=${aConnectedUserObj.userGuidId}';
      Response response = await get(requestStatusUrl);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;
        await LoggerService.log('<RegistrationService> Get Request Status From Server >>> OK\nHeader: $contentType \nRequestStatusFromJSON: $jsonResponse');

        Map<String, dynamic> returnedJson = jsonDecode(jsonResponse);

        String statusFromJson = returnedJson['status'];
        //***** for debug *****
        // When the Server sends back the {loginStatus} correctly >>> remove that calling
        if (GlobalsService.isDebugMode) {
          newLoginObject = await LoginService.readLoginObjectDataFromSecureStorage();
          statusFromJson = EnumToString.parse(newLoginObject.loginStatus);
        }
        //***** for debug *****

        await LoggerService.log('<RegistrationService> Get Request Status From Server >>> $statusFromJson');
        Constants.LoginStatusEnum loginStatus = EnumToString.fromString(Constants.LoginStatusEnum.values, statusFromJson);

        newLoginObject.setLoginStatus(loginStatus);
        await LoginService.writeLoginObjectDataToSecureStorage(loginStatus);

        return newLoginObject;
      } else {
        await LoggerService.log('<RegistrationService> Get Request Status From Server >>> Failed: ${response.statusCode}');
        print('<RegistrationService> Get Request Status From Server >>> Failed: ${response.statusCode}');
        newLoginObject.setLoginStatus(Constants.LoginStatusEnum.NoStatus);
        return newLoginObject;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Get Request Status From Server >>> ERROR: ${e.toString()}');
      developer.log(
        'getRequestStatusFromServer',
        name: 'RegistrationService',
        error: 'Request Status >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region User Registration Add New User [POST]
  // ===============================================================
  Future<Map<String,dynamic>> userRegistrationAddNewUser(ConnectedUserObject aConnectedUserObj) async {
    try {
      Map<String,dynamic> mapResult;

      // Check if a User with a given EMAIl is Already EXIST
      dynamic result = await userRegistrationCheckIsUserAlreadyExist(aConnectedUserObj);
      if (result != null) {
        /// User Exist
        mapResult = {"returnCode": '100', "errorMessage": 'קיים משתמש עם דוא"ל זהה, נסה שוב...'};
      } else {
        /// Add New User Registration Request
        dynamic _userRequestID = await sendUserRegistrationRequestToServer(aConnectedUserObj);
        if (_userRequestID == null) {
          mapResult = {"returnCode": '200', "errorMessage": 'שגיאה ברישום, נסה שוב...'};
        } else {
          mapResult = {"returnCode": '0'};
        }
      }
      return mapResult;
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> User Registration Add New User >>> Server ERROR: ${e.toString()}');
      developer.log(
        'userRegistrationAddNewUser',
        name: 'RegistrationService',
        error: 'Add User >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region User Registration Check Is User Already Exist [POST]
  // ===============================================================
  Future<UserObject> userRegistrationCheckIsUserAlreadyExist(ConnectedUserObject aConnectedUserObj) async {
    try {
      UserObject _userObj;

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        // Check if a User with a given EMAIl is Already EXIST
        dynamic result = await RotaryDataBaseProvider.rotaryDB.getUserByEmail(aConnectedUserObj.email);

        if (result != null) {
          _userObj = result;
          return _userObj;
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
          await LoggerService.log('<RegistrationService> User Registration Check Is User Already Exist At SERVER >>> OK\nHeader: $contentType \nUserRequestID: $checkResult');
          // Return full UserObject (with User Name)
          // currentUserObj.setRequestId(checkResult); // ===>>> if Login Check OK
          return _userObj;
        } else {
          await LoggerService.log('<RegistrationService> User Login Confirm At SERVER >>> Failed: Unable to get UserRequestID: $checkResult');
          print('<RegistrationService> User Login Confirm At SERVER >>> Failed: Unable to get UserRequestID: $checkResult');
          // Return Empty UserObject (without User Name)
          // _userObj = aConnectedUserObj;
          // currentUserObj.setRequestId('-9');  // ===>>> if Login Check Failed
          return _userObj;
        }
      } else {
        await LoggerService.log('<RegistrationService> User Registration Check Is User Already Exist At SERVER >>> Failed: Could not Login >>> ${response.statusCode}');
        print('<RegistrationService> User Registration Check Is User Already Exist At SERVER Failed >>> Could not Login >>> ${response.statusCode}');
        return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> User Registration Check Is User Already Exist At SERVER >>> Server ERROR: ${e.toString()}');
      developer.log(
        'userRegistrationCheckIsUserAlreadyExist',
        name: 'RegistrationService',
        error: 'User Request >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Send User Registration Request To SERVER [POST]
  // ===============================================================
  Future sendUserRegistrationRequestToServer(ConnectedUserObject aConnectedUserObj) async {
    try {

      // In order to add User: Convert ConnectedUserObject ===>>> UserObject
      UserObject _userObj = await UserObject.getUserObjectFromConnectedUserObject(aConnectedUserObj);

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {

        var _userRequestID = await RotaryDataBaseProvider.rotaryDB.insertUser(_userObj);
        return _userRequestID;
        // return '10';
      }
      //***** for debug *****

      // Convert UserObject To Json
      final jsonToPost = aConnectedUserObj.userToJson(aConnectedUserObj);
      print ('sendUserRegistrationRequestToServer / jsonToPost: $jsonToPost');
      Response response = await post(Constants.rotaryUserRegistrationUrl, headers: Constants.rotaryUrlHeader, body: jsonToPost);

      if (response.statusCode <= 300) {
        Map<String, String> headers = response.headers;
        String contentType = headers['content-type'];
        String jsonResponse = response.body;

        String userRequestID = jsonResponse;
        if (int.parse(userRequestID) > 0){
          await LoggerService.log('<RegistrationService> Send Register User Request To SERVER >>> OK\nHeader: $contentType \nUserRequestID: $userRequestID');
          return userRequestID;
        } else {
          await LoggerService.log('<RegistrationService> Send Register User Request To SERVER >>> Failed: Unable to get UserRequestID: $userRequestID');
          print('<RegistrationService> Send Register User Request To SERVER >>> Failed: Unable to get UserRequestID: $userRequestID');
          return null;
        }
      } else {
        await LoggerService.log('<RegistrationService> Send Register User Request To SERVER >>> Failed: Could not Register >>> ${response.statusCode}');
        print('<RegistrationService> Send Register User Request To SERVER Failed >>> Could not Register >>> ${response.statusCode}');
      return null;
      }
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Send Register User Request To SERVER >>> Server ERROR: ${e.toString()}');
      developer.log(
        'sendRegisterUserRequestToServer',
        name: 'RegistrationService',
        error: 'User Request >>> Server ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

}
