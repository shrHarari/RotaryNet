import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/login_object.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/globals_service.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/services/login_service.dart';
import 'package:rotary_net/services/user_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'dart:developer' as developer;

class RegistrationService {

  //#region Get Request Status From Server [GET]
  // =========================================================
  Future<LoginObject> getRequestStatusFromServer(UserObject aUserObj, LoginObject aLoginObject ) async {
    try {
      final UserService personCardService = UserService();
      UserObject newUserObject = aUserObj;
      LoginObject newLoginObject = aLoginObject;

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        return newLoginObject;
      }
      //***** for debug *****

      /// StatusUrl: 'http://159.89.225.231:7775/api/registration/isregistered/requestId={requestId}'
      String requestStatusUrl = '${Constants.rotaryUserRegistrationUrl}=${aUserObj.email}';
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
          newLoginObject = await LoginService.readLoginObjectDataFromSharedPreferences();
          statusFromJson = EnumToString.parse(newLoginObject.loginStatus);
        }
        //***** for debug *****

        await LoggerService.log('<RegistrationService> Get Request Status From Server >>> $statusFromJson');
        Constants.LoginStatusEnum loginStatus = EnumToString.fromString(Constants.LoginStatusEnum.values, statusFromJson);

        newLoginObject.setLoginStatus(loginStatus);
        await LoginService.writeLoginObjectDataToSharedPreferences(loginStatus);

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

  //#region Create User Registration Request Json [JSON]
  // ============================================================
  Future<String> createUserRegistrationRequestJson(UserObject aUserObj) async {
    try {
      DateTime _now = DateTime.now();
      String _formattedDate = DateFormat('yyyy-MM-dd').format(_now);
      String _formattedTime = DateFormat('Hms').format(_now);
      String _formattedDateTime = '${_formattedDate}T${_formattedTime}Z';

      String jsonToPost =
          '{'
            '"email": ${aUserObj.email.toString()}, '
            '"firstName": ${aUserObj.firstName}, '
            '"lastName": ${aUserObj.lastName} '
            '"phoneNumberDialCode": ${aUserObj.phoneNumberDialCode} '
            '"phoneNumberParse": ${aUserObj.phoneNumberParse} '
          '}';

      await LoggerService.log('<RegistrationService> Create User Registration Request JSON: \n$jsonToPost');
      return jsonToPost;
    }
    catch (e) {
      await LoggerService.log('<RegistrationService> Create User Registration Request JSON >>> ERROR: ${e.toString()}');
      developer.log(
        'createUserRegistrationRequestJson',
        name: 'RegistrationService',
        error: 'User Request JSON >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Send User Registration Request To SERVER [POST]
  // ===============================================================
  Future<String> sendUserRegistrationRequestToServer(UserObject aUserObj) async {
    try {
      String jsonToPost = await createUserRegistrationRequestJson(aUserObj);

      //***** for debug *****
      // When the Server side will be ready >>> remove that calling
      if (GlobalsService.isDebugMode) {
        return '10';
      }
      //***** for debug *****

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