import 'dart:async';
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
      String aEmail,
      String aFirstName,
      String aLastName,
      String aPhoneNumber,
      String aPhoneNumberDialCode,
      String aPhoneNumberParse,
      String aPhoneNumberCleanLongFormat) {

    if (aEmail == null)
      return UserObject(
          requestId: Constants.rotaryNoRequestIdInitValue,
          email: '',
          firstName: '',
          lastName: '',
          phoneNumber: '',
          phoneNumberDialCode: '',
          phoneNumberParse: '',
          phoneNumberCleanLongFormat: '');
    else
      return UserObject(
          requestId: aRequestId,
          email: aEmail,
          firstName: aFirstName,
          lastName: aLastName,
          phoneNumber: aPhoneNumber,
          phoneNumberDialCode: aPhoneNumberDialCode,
          phoneNumberParse: aPhoneNumberParse,
          phoneNumberCleanLongFormat: aPhoneNumberCleanLongFormat);
  }
  //#endregion

  //#region Read User Object Data From Shared Preferences [ReadFromSP]
  //=============================================================================
  Future<UserObject> readUserObjectDataFromSharedPreferences() async {
    String _requestId;
    String _email;
    String _firstName;
    String _lastName;
    String _phoneNumber;
    String _phoneNumberDialCode;
    String _phoneNumberParse;
    String _phoneNumberCleanLongFormat;

    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      _requestId = prefs.getString(Constants.rotaryUserRequestId);
      _email = prefs.getString(Constants.rotaryUserEmail);
      _firstName = prefs.getString(Constants.rotaryUserFirstName);
      _lastName = prefs.getString(Constants.rotaryUserLastName);
      _phoneNumber = prefs.getString(Constants.rotaryUserPhoneNumber);
      _phoneNumberDialCode = prefs.getString(Constants.rotaryUserPhoneNumberDialCode);
      _phoneNumberParse = prefs.getString(Constants.rotaryUserPhoneNumberParse);
      _phoneNumberCleanLongFormat = prefs.getString(Constants.rotaryUserPhoneNumberCleanLongFormat);

      return createUserAsObject(
          _requestId,
          _email,
          _firstName,
          _lastName,
          _phoneNumber,
          _phoneNumberDialCode,
          _phoneNumberParse,
          _phoneNumberCleanLongFormat);
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
      await prefs.setString(Constants.rotaryUserEmail, aUserObj.email);
      await prefs.setString(Constants.rotaryUserFirstName, aUserObj.firstName);
      await prefs.setString(Constants.rotaryUserLastName, aUserObj.lastName);
      await prefs.setString(Constants.rotaryUserPhoneNumber, aUserObj.phoneNumber);
      await prefs.setString(Constants.rotaryUserPhoneNumberDialCode, aUserObj.phoneNumberDialCode);
      await prefs.setString(Constants.rotaryUserPhoneNumberParse, aUserObj.phoneNumberParse);
      await prefs.setString(Constants.rotaryUserPhoneNumberCleanLongFormat, aUserObj.phoneNumberCleanLongFormat);
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

  //#region Clear User Object Data From Shared Preferences
  //=============================================================================
  Future clearUserObjectDataFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.rotaryUserRequestId);
      await prefs.remove(Constants.rotaryUserEmail);
      await prefs.remove(Constants.rotaryUserFirstName);
      await prefs.remove(Constants.rotaryUserLastName);
      await prefs.remove(Constants.rotaryUserPhoneNumber);
      await prefs.remove(Constants.rotaryUserPhoneNumberDialCode);
      await prefs.remove(Constants.rotaryUserPhoneNumberParse);
      await prefs.remove(Constants.rotaryUserPhoneNumberCleanLongFormat);
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
}
