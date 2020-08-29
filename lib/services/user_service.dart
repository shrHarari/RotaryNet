import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rotary_net/objects/user_object.dart';
import 'package:rotary_net/services/logger_service.dart';
import 'package:rotary_net/shared/constants.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class UserService {

  //#region Create User As Object
  //=============================================================================
  UserObject createUserAsObject(
      String aRequestId,
      String aEmailId,
      String aFirstName,
      String aLastName,
      String aPassword,
      Constants.UserTypeEnum aUserType,
      bool aStayConnected) {

    if (aEmailId == null)
      return UserObject(
          requestId: Constants.rotaryNoRequestIdInitValue,
          emailId: '',
          firstName: '',
          lastName: '',
          password: '',
          userType: Constants.UserTypeEnum.SystemAdmin,
          stayConnected: false);
    else
      return UserObject(
          requestId: aRequestId,
          emailId: aEmailId,
          firstName: aFirstName,
          lastName: aLastName,
          password: aPassword,
          userType: aUserType,
          stayConnected: aStayConnected);
  }
  //#endregion

  //#region Read User Object Data From Shared Preferences [ReadFromSP]
  //=============================================================================
  Future<UserObject> readUserObjectDataFromSharedPreferences() async {
    String _requestId;
    String _emailId;
    String _firstName;
    String _lastName;
    String _password;
    Constants.UserTypeEnum _userType;
    bool _stayConnected = false;

    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      _requestId = prefs.getString(Constants.rotaryUserRequestId);
      _emailId = prefs.getString(Constants.rotaryUserEmailId);
      _firstName = prefs.getString(Constants.rotaryUserFirstName);
      _lastName = prefs.getString(Constants.rotaryUserLastName);
      _password = prefs.getString(Constants.rotaryUserPassword);
      _userType = EnumToString.fromString(Constants.UserTypeEnum.values, prefs.getString(Constants.rotaryUserType));
      _stayConnected = prefs.getBool(Constants.rotaryUserStayConnected);

      return createUserAsObject(
          _requestId,
          _emailId,
          _firstName,
          _lastName,
          _password,
          _userType,
          _stayConnected);
    }
    catch  (e) {
      await LoggerService.log('<UserService> Read User Object Data From SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'readUserObjectDataFromSharedPreferences',
        name: 'UserService',
        error: 'Read User Object Data From SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write User Object Data To Shared Preferences [WriteToSP]
  //=============================================================================
  Future writeUserObjectDataToSharedPreferences(UserObject aUserObj) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.rotaryUserRequestId, aUserObj.requestId);
      await prefs.setString(Constants.rotaryUserEmailId, aUserObj.emailId);
      await prefs.setString(Constants.rotaryUserFirstName, aUserObj.firstName);
      await prefs.setString(Constants.rotaryUserLastName, aUserObj.lastName);
      await prefs.setString(Constants.rotaryUserPassword, aUserObj.password);
      await prefs.setString(Constants.rotaryUserType, EnumToString.parse(aUserObj.userType));
      await prefs.setBool(Constants.rotaryUserStayConnected, aUserObj.stayConnected);
    }
    catch  (e) {
      await LoggerService.log('<UserService> Write User Object Data To SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'writeUserObjectDataToSharedPreferences',
        name: 'UserService',
        error: 'Write User Object Data To SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Write User Type To Shared Preferences [WriteToSP]
  //=============================================================================
  Future writeUserTypeToSharedPreferences(Constants.UserTypeEnum aUserType) async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.rotaryUserType, EnumToString.parse(aUserType));
    }
    catch  (e) {
      await LoggerService.log('<UserService> Write User Type To SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'writeUserTypeToSharedPreferences',
        name: 'UserService',
        error: 'Write User Type To SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Clear User Object Data From Shared Preferences
  //=============================================================================
  Future clearUserObjectDataFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.rotaryUserRequestId);
      await prefs.remove(Constants.rotaryUserEmailId);
      await prefs.remove(Constants.rotaryUserFirstName);
      await prefs.remove(Constants.rotaryUserLastName);
      await prefs.remove(Constants.rotaryUserPassword);
      await prefs.remove(Constants.rotaryUserType);
      await prefs.remove(Constants.rotaryUserStayConnected);
    }
    catch (e){
      await LoggerService.log('<UserService> Clear User Object Data From SharedPreferences >>> ERROR: ${e.toString()}');
      developer.log(
        'clearUserObjectDataFromSharedPreferences',
        name: 'UserService',
        error: 'Clear User Object Data From SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
  //#endregion

  //#region Exit From Application Update Shared Preferences
  //=============================================================================
  Future exitFromApplicationUpdateSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
//      await prefs.remove(Constants.rotaryUserPassword);
      await prefs.remove(Constants.rotaryUserStayConnected);
    }
    catch (e){
      await LoggerService.log('<UserService> Exit From Application Update Shared Preferences >>> ERROR: ${e.toString()}');
      developer.log(
        'exitFromApplicationUpdateSharedPreferences',
        name: 'UserService',
        error: 'Exit From Application Update SharedPreferences >>> ERROR: ${e.toString()}',
      );
      return null;
    }
  }
//#endregion
}
